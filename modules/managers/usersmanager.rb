module UsersManager
  attr_accessor :banned_group_names, :banned_user_names

  def new
    @banned_user_names = Array.new
    @banned_group_names = Array.new
    load_banned_group_names
    load_banned_user_names
  end

  def load_banned_user_names
    #Check if the user in /etc/passwd is in the database. If not, it's a banned user name.
    File.foreach('/etc/passwd'){ |l|
      user_name = l.split(':')[0]
      if($db.users.where(:user_name => user_name).empty?)
        @banned_user_names << user_name
      end
    }
  end

  def load_banned_group_names
    #Check if the group in /etc/group is in the database. If not, it's a banned group name.
    File.foreach('/etc/group'){ |l|
      group_name = l.split(':')[0]
      if $db.groups.where(:group_name => group_name).empty?
        @banned_group_names << group_name
      end
    }
  end

  def add_group(name)
    unless @banned_group_names.include?(name)
      if $db.groups.where(:group_name => name).empty?
        result = system("groupadd #{name}")
        if result
          $db.groups.insert(:group_name => name, :members => '')
          return true
        else
          return false
        end
      end
    end
    return false
  end

  def add_user(name, password, group = 'EdenManager', shell = '/bin/bash') #TODO: Implement real returns to this function with the exact error.
    unless @banned_user_names.include?(name) #If the username is not banned (already in use)
      if $db.users.where(:user_name => name).empty? && group_exist?(group)
        random_salt = SecureRandom.hex(5)
        crypted_password = password.crypt("$6$#{random_salt}")
        result = system("useradd -m -p '#{crypted_password}' -d '/opt/EdenManager/EdenApps' -g '#{group}' -s '#{shell}' #{name}")
        if result
          user_informations = IO.readlines('/etc/passwd').last.split(':')
          $db.users.insert(:user_name => name, :user_gid => user_informations[2], :primary_group => group)
          new_member_list = $db.groups.where(:group_name => group).first[:members] + ":#{name}"
          $db.groups.where(:group_name => group).update(:members => new_member_list)
          return true
        else
          return false
        end
      end
    end
    return false
  end

  def group_exist?(name)
    if $db.groups.where(:group_name => name).empty?
      return false
    else
      return true
    end
  end
end