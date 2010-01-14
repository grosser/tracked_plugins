module Commands
  class Base
    def initialize(base_command)
      @base_command = base_command
    end

    def base_dir
      "#{@base_command.environment.root}/vendor/plugins"
    end
  end
end