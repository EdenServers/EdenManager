module UsersManager
  attr_accessor :banned_group_names, :banned_user_names

  def new
    @banned_user_names = Array.new
    @banned_group_names = Array.new
    load_banned_group_names
    load_banned_user_names
    install_default_users
  end

  def install_default_users
    if $db.groups.where(:group_name => 'EdenManager').empty?
      group = check_group_in_system('EdenManager')
      if(!group)
        add_group('EdenManager')
      else
        $db.groups.insert(:group_name => 'EdenManager', :members => '')
      end
    end
    if $db.users.where(:user_name => 'EdenManager').empty?
      account = check_account_in_system('EdenManager')
      if(!account)
        add_user('EdenManager', SecureRandom.hex(5))
      else
        $db.users.insert(:user_name => account[0], :user_gid => account[2], :primary_group => 'EdenManager')
      end
    end
  end

  def load_banned_user_names
    #Check if the user in /etc/passwd is in the database. If not, it's a banned user name.
    File.foreach('/etc/passwd'){ |l|
      user_name = l.split(':')[0]
      if $db.users.where(:user_name => user_name).empty?
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

  def change_password (name, password)
    Open3.popen3("echo \"#{password}\n#{password}\" | passwd #{name}") {|stdin, stdout, stderr, wait_thr| #hacky, must be changed in the future
      exit_status = wait_thr.value.exitstatus
      if !stderr.nil?
        stderr.readlines.each do |e|
          error = e.gsub("\n", '')  # we do not want new lines
          case exit_status
            when 0 #all is fine
              Console.show error, 'warn'
              Console.show "Password of user: #{name} changed", 'info'
              return true
            when 1 # Permission denied : user invalid
                   #TODO: Report to the website the error
              Console.show error, 'error'
              false
            when 5 # Passwd file busy
                   #TODO: Report to the website the error
              Console.show error, 'error'
              false
            else
              #Unknown error, should be reported on edenservers' forum
              Console.show error, 'error'
              false
          end
        end
      else
        true
      end
    }
  end

  def check_account_in_system(name)
    File.foreach('/etc/passwd'){ |l|
      if account = l.split(':')[0] == name
        return account
      end
    }
    return false
  end

  def check_group_in_system(name)
    File.foreach('/etc/group'){ |l|
      if group = l.split(':')[0] == name
        return group
      end
    }
    return false
  end

end