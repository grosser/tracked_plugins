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
          puts full_info(name, info)
        else
          puts name
        end
      end
    end

    def full_info(name, info)
      info[:locally_modified] = ::Plugin.locally_modified_info("#{base_dir}/#{name}")
      info[:updateable] = updateable_info(name, info)
      out = info.map{|k,v| "#{k}: #{v}"}.sort * "\n"
      if @show_log
        out += "\n"
        out += "available updates:\n"
        out += ::Plugin.plugin_revision_log(info[:uri], :starting_at => info[:revision], :branch=>info[:branch])
      end
      out
    end

    def updateable_info(name, info)
      if info[:revision].to_s.empty?
        'Unknown'
      elsif ::Plugin.repository_revision(info[:uri], :branch => info[:branch]) == info[:revision]
        'No'
      else
        @show_log ? 'Yes' : "Yes -> #{@base_command.script_name} info #{@name} --log"
      end
    end
  end
end