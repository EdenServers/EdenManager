#Console helper provides methods to interract with console
module Console

  #Print a message 
  # 6 types of messages : info, error, warn, success, debug or nil
  def show (msg = '', type = '')
    log = Logger.new('server.log')
    if msg == ''
      puts "#{Time.now} [ERROR] Undefined message".red
      log.unknown msg
    else
      case type
        when 'info'
          puts "#{Time.now} [INFO] #{msg}".blue
          log.info msg
        when 'error'
          STDERR.puts "#{Time.now} [ERROR] #{msg}".red
          log.error msg
        when 'warn'
          puts "#{Time.now} [WARNING] #{msg}".magenta
          log.unknown msg
        when 'success'
          puts "#{Time.now} [SUCCESS] #{msg}".green
          log.unknown msg
        when 'debug'
          if(Configuration.config['debug'] == 1)
            puts "#{Time.now} [DEBUG] #{msg}".yellow
            log.debug msg
          end
        when 'log'
          log.debug msg
        else
          puts "#{Time.now} #{msg}"
          log.unknown msg
      end
    end
  end
end

include Console