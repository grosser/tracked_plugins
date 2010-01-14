# overwrite list to show installed repositories
module Commands
  class List
    def initialize(base_command)
      @base_command = base_command
    end

    def options
    end

    def parse!(args)
      cd base_dir
      Dir["*"].select{|p| File.directory?(p)}.each do |name|
        puts one_line_summary(name)
      end
    end

    def one_line_summary(name)
      if info = ::Plugin.info_for_plugin("#{base_dir}/#{name}")
        "#{name} #{info[:uri]} #{info[:revision]} #{info[:installed_at].to_s(:db)}"
      else
        name
      end
    end

    def base_dir
      "#{@base_command.environment.root}/vendor/plugins"
    end
  end
end