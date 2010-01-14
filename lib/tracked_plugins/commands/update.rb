# overwrite to do revision based updates
module Commands
  class Update
    def initialize(base_command)
      @base_command = base_command
    end

    def options
      OptionParser.new do |o|
        o.set_summary_indent('  ')
        o.banner =    "Usage: #{@base_command.script_name} update name"
        o.on(         "-r REVISION", "--revision REVISION", "Checks out this revision."){ |v| @revision = v }
        o.define_head "Update plugins by reinstalling them."
      end
    end

    def parse!(args)
      options.parse!(args)
      args.each do |name|
        info = ::Plugin.info_for_plugin("#{base_dir}/#{name}")
        if info and info[:uri]
          if info[:revision] == ::Plugin.repository_revision(info[:uri])
            puts "Plugin is up to date: #{name} (#{info[:revision]})"
          else
            puts "Reinstalling plugin: #{name} (#{info[:revision]})"
            `script/plugin install --force #{info[:uri]}`
          end
        else
          puts "No meta info found: #{name}"
        end
      end
    end

    def base_dir
      "#{@base_command.environment.root}/vendor/plugins"
    end
  end
end