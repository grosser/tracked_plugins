require File.join(File.dirname(__FILE__), 'old_script_plugin')

# get alias_method_chain
require 'active_support/core_ext/array'
require 'active_support/core_ext/module'
require 'active_support/core_ext/time'


class Plugin
  INFO_STORAGE = 'PLUGIN_INFO.yml'

  # overwrite install to add version information
  def run_install_hook_with_add_info(*args)
    run_install_hook_without_add_info(*args)
    File.open(info_yml, 'w') do |f|
      info =  {
        :uri => @uri,
        :installed_at => Time.now,
        :revision => repository_revision
      }
      f.write info.to_yaml
    end
  end

  def repository_revision
    if git_url?
      temp = '/tmp/get_me_a_revision'
      `rm -rf #{temp}`
      `cd /tmp && git clone --no-checkout --depth 1 #{@uri} get_me_a_revision`
      revision = `cd #{temp} && git log --pretty=format:%H -1`.strip
      `rm -rf #{temp}`
      revision
    else # svn:// or http://
      `svn info #{@uri}`.match(/Revision: (\d+)/)[1]
    end
  end

  def info_yml
    "#{rails_env.root}/vendor/plugins/#{name}/#{INFO_STORAGE}"
  end
  alias_method_chain :run_install_hook, :add_info
end

module Commands
  # overwrite list to show installed repositories
  class List
    def initialize(base_command)
      @base_command = base_command
    end

    def options
    end

    def parse!(args)
      cd base_dir
      Dir["*"].select{|p| File.directory?(p)}.each do |name|
        puts info_for_plugin(name)
      end
    end

    def info_for_plugin(name)
      info = File.join(base_dir, name, ::Plugin::INFO_STORAGE)
      if File.exist?(info)
        info = YAML.load(File.read(info))
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

Commands::Plugin.parse!