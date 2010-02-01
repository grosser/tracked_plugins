class Plugin
  INFO_STORAGE = 'PLUGIN_INFO.yml'

  # overwrite install hook to add version information
  def run_install_hook_with_store_info(*args)
    run_install_hook_without_store_info(*args)
    store_info_to_yml
  end
  alias_method_chain :run_install_hook, :store_info

  # overwrite install to store options for later use (very hacky...)
  def install_with_options_store(*args)
    @temp_install_options = args.reverse.detect{|a| a.is_a?(Hash) }
    install_without_options_store(*args)
  end
  alias_method_chain :install, :options_store

  def store_info_to_yml
    install_options = @temp_install_options || {}
    File.open(info_yml, 'w') do |f|
      info =  {
        :uri => @uri,
        :installed_at => Time.now,
        :revision => self.class.repository_revision(@uri, install_options),
        :checksum => self.class.checksum(install_dir)
      }
      f.write info.to_yaml
    end
  end

  def install_dir
    "#{rails_env.root}/vendor/plugins/#{name}"
  end

  def info_yml
    "#{install_dir}/#{INFO_STORAGE}"
  end

  def self.checksum(dir)
    files = (Dir["#{dir}/**/*"]-["#{dir}/#{INFO_STORAGE}"]).reject{|f| File.directory?(f)}
    content = files.map{|f| File.read(f)}.join
    require 'md5'
    MD5.md5(content).to_s
  end

  def self.locally_modified(dir)
    info = info_for_plugin(dir) || {}
    if info[:checksum]
      (info[:checksum] == checksum(dir)) ? 'No' : 'Yes'
    else
      'Unknown'
    end
  end

  def self.repository_revision(uri, options={})
    if self.new(uri).git_url?
      git_checkout_and_do(uri, 'git log --pretty=format:%H -1', :branch=>options[:revision])
    else # svn:// or http://
      return options[:revision] if options[:revision]
      `svn info #{uri}`.match(/Revision: (\d+)/)[1]
    end
  end

  def self.info_for_plugin(dir)
    file = "#{dir}/#{::Plugin::INFO_STORAGE}"
    if File.exist?(file)
      YAML.load(File.read(file))
    else
      nil
    end
  end

  def self.plugin_revision_log(uri, options={})
    if self.new(uri).git_url?
      git_checkout_and_do(uri, "git log --pretty=format:'%H %cr %s' #{options[:starting_at ]}..HEAD", :branch=>options[:revision])
    else # svn:// or http://
      `svn info #{uri}`.match(/Revision: (\d+)/)[1]
    end
  end

  def self.git_checkout_and_do(uri, git_cmd, options={})
    temp = '/tmp/get_me_a_revision'
    `rm -rf #{temp}`
    if options[:branch]
      `mkdir #{temp}`
      `cd #{temp} && git init && git pull --depth 1 #{uri} #{options[:branch]}`
    else
      `cd /tmp && git clone --no-checkout #{uri} get_me_a_revision`
    end
    revision = `cd #{temp} && #{git_cmd}`.strip
    `rm -rf #{temp}`
    revision
  end
end