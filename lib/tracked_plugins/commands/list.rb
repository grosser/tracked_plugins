# overwrite list to show installed repositories
module Commands
  class List < Commands::Base
    def parse!(args)
      cd base_dir
      Dir["*"].select{|p| File.directory?(p)}.sort.each do |name|
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
  end
end