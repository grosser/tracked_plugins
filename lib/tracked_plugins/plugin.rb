class Plugin
  INFO_STORAGE = 'PLUGIN_INFO.yml'

  # overwrite install to add version information
  def run_install_hook_with_add_info(*args)
    run_install_hook_without_add_info(*args)
    store_info_to_yml
  end
  alias_method_chain :run_install_hook, :add_info

  def store_info_to_yml
    File.open(info_yml, 'w') do |f|
      info =  {
        :uri => @uri,
        :installed_at => Time.now,
        :revision => self.class.repository_revision(@uri),
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

  def self.repository_revision(uri)
    if self.new(uri).git_url?
      git_checkout_and_do(uri, '--no-checkout --depth 1', 'git log --pretty=format:%H -1')
    else # svn:// or http://
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
      git_checkout_and_do(uri, '--no-checkout', "git log --pretty=format:'%H %cr %s' #{options[:starting_at ]}..HEAD")
    else # svn:// or http://
      `svn info #{uri}`.match(/Revision: (\d+)/)[1]
    end
  end

  def self.git_checkout_and_do(uri, checkout_args, git_cmd)
    temp = '/tmp/get_me_a_revision'
    `rm -rf #{temp}`
    `cd /tmp && git clone #{checkout_args} #{uri} get_me_a_revision`
    revision = `cd #{temp} && #{git_cmd}`.strip
    `rm -rf #{temp}`
    revision
  end
end