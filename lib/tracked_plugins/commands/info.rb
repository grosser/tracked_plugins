module Commands
  # overwrite info to give some helpful info
  class Info < Commands::Base
    def options
      OptionParser.new do |o|
        o.set_summary_indent('  ')
        o.banner =    "Usage: #{@base_command.script_name} info name [name]..."
        o.define_head "Shows plugin info."
        o.separator   ""
        o.separator   "Options:"
        o.on(         "-l", "--log", "Show log of available updates.") {|show_log|  @show_log = show_log}
      end
    end

    def parse!(args)
      options.parse!(args)
      args.each do |name|
        dir = "#{base_dir}/#{name}"
        if info = ::Plugin.info_for_plugin(dir)
          info[:locally_modified] = ::Plugin.locally_modified("#{base_dir}/#{name}")
          info[:updateable] = updateable_info(name, info)
          puts info.map{|k,v| "#{k}: #{v}"}.sort * "\n"
          if @show_log
            puts ''
            puts "available updates:"
            puts ::Plugin.plugin_revision_log(info[:uri], :starting_at => info[:revision])
          end
        else
          puts name
        end
      end
    end

    def updateable_info(name, info)
      if info[:revision].to_s.empty?
        'Unknown'
      elsif ::Plugin.repository_revision(info[:uri]) == info[:revision]
        'No'
      else
        @show_log ? 'Yes' : "Yes -> #{@base_command.script_name} info #{@name} --log"
      end
    end
  end
end