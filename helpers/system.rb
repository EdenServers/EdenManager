module System
  def create_account (name, password, options = {}) #Options : home_folder, group, loggable
    Open3.popen3("useradd #{name} #{"-d #{options[:home_folder]}" if !options[:home_folder].nil?} #{"-G #{options[:group]}" if !options[:group].nil?}  -m #{'-s /bin/false' if !options[:loggable]} -p $(mkpasswd -H md5 #{password})") {|stdin, stdout, stderr, wait_thr|
      exit_status = wait_thr.value.exitstatus
      if !stderr.nil?
        stderr.readlines.each do |e|
          error = e.gsub("\n", '')  # we do not want new lines
          case exit_status
            when 0 #all is fine
              Console.show error, 'warn'
              true
            when 6 #group doesn't exist
              #TODO: Report to the website the error
              Console.show error, 'error'
              false
            when 9 #user already exist
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

  def delete_account (name, remove_home)
    Open3.popen3("deluser #{name} #{'--remove-home' if remove_home}") {|stdin, stdout, stderr, wait_thr|
      exit_status = wait_thr.value.exitstatus
      if !stderr.nil?
        stderr.readlines.each do |e|
          error = e.gsub("\n", '')  # we do not want new lines
          case exit_status
            when 0 #all is fine
              Console.show error, 'warn'
              true
            when 2 # There is no such user.
              #TODO: Report to the website the error
              Console.show error, 'error'
              false
            when 9 #trying to delete root account
              #TODO: Report to the website the error
              Console.show 'The manager doesn\'t allow to remove the root account', 'error'
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
end
include System