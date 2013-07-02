# The monitoring methods are from Bluepill ( https://github.com/arya/bluepill )

module Monitoring
  module System

    # The position of each field in ps output
    IDX_MAP = {
        :pid => 0,
        :ppid => 1,
        :pcpu => 2,
        :rss => 3,
        :etime => 4
    }

    def daemonize(cmd, options = {})
      rd, wr = IO.pipe
      if child = Daemonize.safefork
        # parent
        ::Process.detach(child)
        wr.close
        daemon_id = rd.read.to_i
        rd.close

        return daemon_id if daemon_id > 0

      else
        # child
        rd.close
        set_user(options[:utilisateur]) if !options[:utilisateur].nil?

        to_daemonize = lambda do
          # Setting up the working_dir
          Dir.chdir(ENV['PWD'] = options[:working_dir].to_s) if options[:working_dir]
          #redirect_io(*options.values_at(:stdin, :stdout, :stderr))

          ::Kernel.exec(*Shellwords.shellwords(cmd))
          exit
        end

        daemon_id = Daemonize.call_as_daemon(to_daemonize, nil, cmd)

        File.open(options[:pid_file], 'w') {|f| f.write(daemon_id)}

        wr.write daemon_id
        wr.close
        exit
      end
    end

    #Launch the program as a specific User.
    def set_user(uid)
      if ::Process::Sys.geteuid == 0
        uid_num = Etc.getpwnam(uid).uid if uid
        ::Process::Sys.setuid(uid_num) if uid
      end
    end

    def cpu_usage(pid, include_children)
      ps = ps_axu
      return unless ps[pid]
      cpu_used = ps[pid][IDX_MAP[:pcpu]].to_f
      get_children(pid).each { |child_pid|
        cpu_used += ps[child_pid][IDX_MAP[:pcpu]].to_f if ps[child_pid]
      } if include_children
      cpu_used
    end

    def memory_usage(pid, include_children)
      ps = ps_axu
      return unless ps[pid]
      mem_used = ps[pid][IDX_MAP[:rss]].to_f
      get_children(pid).each { |child_pid|
        mem_used += ps[child_pid][IDX_MAP[:rss]].to_f if ps[child_pid]
      } if include_children
      (mem_used*0.1).to_i / 100.0
    end

    def running_time(pid)
      ps = ps_axu
      return unless ps[pid]
      parse_elapsed_time(ps[pid][IDX_MAP[:etime]])
    end

    def get_children(parent_pid)
      child_pids = Array.new
      ps_axu.each_pair do |pid, chunks|
        child_pids << chunks[IDX_MAP[:pid]].to_i if chunks[IDX_MAP[:ppid]].to_i == parent_pid.to_i
      end
      grand_children = child_pids.map{|pid| get_children(pid)}.flatten
      child_pids.concat grand_children
    end

    def parse_elapsed_time(str)
      # [[dd-]hh:]mm:ss
      if str =~ /(?:(?:(\d+)-)?(\d\d):)?(\d\d):(\d\d)/
        days = ($1 || 0).to_i
        hours = ($2 || 0).to_i
        mins = $3.to_i
        secs = $4.to_i
        ((days*24 + hours)*60 + mins)*60 + secs
      else
        0
      end
    end

    def store
      @store ||= Hash.new
    end

    def reset_ps_axu
      @store = nil
    end

    def ps_axu
      store[:ps_axu] ||= begin
        # BSD style ps invocation
        lines = `ps axo pid,ppid,pcpu,rss,etime`.split("\n")

        lines.inject(Hash.new) do |mem, line|
          chunks = line.split(/\s+/)
          chunks.delete_if {|c| c.strip.empty? }
          pid = chunks[IDX_MAP[:pid]].strip.to_i
          mem[pid] = chunks
          mem
        end
      end
    end
  end
end
