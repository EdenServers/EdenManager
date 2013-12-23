module UsersManager
  attr_accessor :banned_group_names, :banned_user_names, :users, :groups

  @banned_user_names = Array.new
  @banned_group_names = Array.new
  @groups = Array.new
  @users = Array.new

  def self.new
    load_banned_group_names
    load_banned_user_names
    load_users_and_groups
    install_default_users
    check_permissions
  end

  def self.install_default_users
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

  def self.get_group_list
    @groups
  end

  def self.get_user_list
    @users
  end

  def self.load_banned_user_names
    #Check if the user in /etc/passwd is in the database. If not, it's a banned user name.
    File.foreach('/etc/passwd'){ |l|
      user_name = l.split(':')[0]
      if $db.users.where(:user_name => user_name).empty?
        @banned_user_names << user_name
      end
    }
  end

  def self.load_users_and_groups
    $db.groups.all.each do |group|
      @groups << group[:group_name]
    end
    $db.users.all.each do |user|
      @users << user[:user_name]
    end
  end

  def self.load_banned_group_names
    #Check if the group in /etc/group is in the database. If not, it's a banned group name.
    File.foreach('/etc/group'){ |l|
      group_name = l.split(':')[0]
      if $db.groups.where(:group_name => group_name).empty?
        @banned_group_names << group_name
      end
    }
  end

  def self.add_group(name)
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

  def self.add_user(name, password, group='EdenManager', shell='/bin/bash', home_directory='/opt/EdenManager/EdenApps') #TODO: Implement real returns to this function with the exact error.
    group = 'EdenManager' if group.nil?
    shell = '/bin/bash' if group.nil?
    home_directory = '/opt/EdenManager/EdenApps' if home_directory.nil?
    unless @banned_user_names.include?(name) #If the username is not banned (already in use)
      if $db.users.where(:user_name => name).empty? && group_exist?(group)
        random_salt = SecureRandom.hex(5)
        crypted_password = password.crypt("$6$#{random_salt}")
        result = system("useradd -m -p '#{crypted_password}' -d #{home_directory} -g '#{group}' -s '#{shell}' #{name}")
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

  def self.group_exist?(name)
    if $db.groups.where(:group_name => name).empty?
      return false
    else
      return true
    end
  end

  def self.change_password (name, password)
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

  def self.check_account_in_system(name)
    File.foreach('/etc/passwd'){ |l|
      account = l.split(':')
      if account[0] == name
        return account
      end
    }
    return false
  end

  def self.check_group_in_system(name)
    File.foreach('/etc/group'){ |l|
      group = l.split(':')[0]
      if group  == name
        return group
      end
    }
    return false
  end

  def self.check_permissions
    #Checking and setting permissions of EdenApps if the permissions are broken
    if File.exist? 'EdenApps'
      File.chmod(0755, 'EdenApps')
      Dir.foreach('EdenApps') do |file|
        File.chmod(0555,"EdenApps/#{file}")
      end
    end
  end
end