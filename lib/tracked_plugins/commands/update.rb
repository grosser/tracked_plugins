# overwrite to do revision based updates
module Commands
  class Update < Commands::Base
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
          branch = (info[:branch] ? " branch: #{info[:branch]}" : '')
          if info[:revision] == ::Plugin.repository_revision(info[:uri], :revision => info[:branch])
            puts "Plugin is up to date: #{name}#{branch} (#{info[:revision]})"
          else
            puts "Reinstalling plugin: #{name}#{branch} (#{info[:revision]})"
            command = (@base_command.script_name == 'rails' ? 'rails plugin' : @base_command.script_name)
            revision_arg = (info[:branch] ? " --revision #{info[:branch]}" : '')
            `#{command} install --force #{info[:uri]}#{revision_arg}`
          end
        else
          puts "No meta info found: #{name}"
        end
      end
    end
  end
end