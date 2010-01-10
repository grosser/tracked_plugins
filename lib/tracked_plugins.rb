require File.join(File.dirname(__FILE__), 'old_script_plugin')

# get alias_method_chain
require 'active_support/core_ext/array'
require 'active_support/core_ext/module'

# .to_s(:db)
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
        :revision => self.class.repository_revision(@uri)
      }
      f.write info.to_yaml
    end
  end
  alias_method_chain :run_install_hook, :add_info

  def info_yml
    "#{rails_env.root}/vendor/plugins/#{name}/#{INFO_STORAGE}"
  end

  def self.repository_revision(uri)
    if self.new(uri).git_url?
      temp = '/tmp/get_me_a_revision'
      `rm -rf #{temp}`
      `cd /tmp && git clone --no-checkout --depth 1 #{uri} get_me_a_revision`
      revision = `cd #{temp} && git log --pretty=format:%H -1`.strip
      `rm -rf #{temp}`
      revision
    else # svn:// or http://
      `svn info #{uri}`.match(/Revision: (\d+)/)[1]
    end
  end

  def self.info_for_plugin(base, name)
    file = File.join(base, name, ::Plugin::INFO_STORAGE)
    if File.exist?(file)
      YAML.load(File.read(file))
    else
      nil
    end
  end
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
      if info = ::Plugin.info_for_plugin(base_dir, name)
        "#{name} #{info[:uri]} #{info[:revision]} #{info[:installed_at].to_s(:db)}"
      else
        name
      end
    end

    def base_dir
      "#{@base_command.environment.root}/vendor/plugins"
    end
  end

  # overwrite to do revision based updates
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
        info = ::Plugin.info_for_plugin(base_dir, name)
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

# always complains when reinstalling, even though there is not externals!
class RailsEnvironment
  def externals_with_svn_check=(items)
    externals_without_svn_check=(items) if use_externals?
  end
  alias_method_chain :externals=, :svn_check
end

Commands::Plugin.parse!