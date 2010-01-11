require 'rubygems'
require 'yaml'

current = File.expand_path(File.dirname(File.dirname(__FILE__)))
TEST_RAILS = File.join(current, 'spec', 'rails')

# cleanup old test rails project
`rm -rf #{TEST_RAILS}`

# create a new test rails project that has this plugin installed
`cd #{current}/spec && rails rails`
copy = "#{TEST_RAILS}/vendor/plugins/#{File.basename(current)}"
`ln -s #{current} #{copy}`
`cd #{TEST_RAILS} && ruby -e 'load "#{copy}/install.rb"'` # simulate install hook

GIT_PLUGIN = "git://github.com/grosser/xhr_redirect.git"
SVN_PLUGIN = "http://small-plugins.googlecode.com/svn/trunk/will_paginate_acts_as_searchable"

def install_plugin(uri)
  `cd #{TEST_RAILS} && script/plugin install #{uri}`
  name = uri.match(%r{/([^/]+?)(\.git)?$})[1]
  plugin_folder = "#{TEST_RAILS}/vendor/plugins/#{name}"
  [name, plugin_folder]
end

describe "installing from git" do
  before :all do
    @uri = GIT_PLUGIN
    @name, @plugin_folder = install_plugin(@uri)
  end

  after :all do
    `rm -rf #{@plugin_folder}`
  end

  def plugin_info
    YAML.load(File.read("#{@plugin_folder}/PLUGIN_INFO.yml"))
  end

  it "checks out the plugin" do
    File.exist?(@plugin_folder).should == true
  end

  it "creates a PLUGIN_INFO.yml" do
    File.exist?("#{@plugin_folder}/PLUGIN_INFO.yml").should == true
  end

  it "writes correct commit" do
    plugin_info[:revision].should =~ /^[\da-f]{40}$/
  end

  it "writes correct installed_at" do
    plugin_info[:installed_at].should be_close(Time.now, 5)
  end

  it "writes correct uri" do
    plugin_info[:uri].should == @uri
  end

  it "writes correct checksum" do
    plugin_info[:checksum].should =~ /^[\da-f]{32}$/
  end
end

describe "installing from svn" do
  before :all do
    @uri = SVN_PLUGIN
    @name, @plugin_folder = install_plugin(@uri)
  end

  after :all do
    `rm -rf #{@plugin_folder}`
  end

  def plugin_info
    YAML.load(File.read("#{@plugin_folder}/PLUGIN_INFO.yml"))
  end

  it "checks out the plugin" do
    File.exist?(@plugin_folder).should == true
  end

  it "creates a PLUGIN_INFO.yml" do
    File.exist?("#{@plugin_folder}/PLUGIN_INFO.yml").should == true
  end

  it "writes correct commit" do
    plugin_info[:revision].should =~ /^\d+$/
  end

  it "writes correct installed_at" do
    plugin_info[:installed_at].should be_close(Time.now, 5)
  end

  it "writes correct uri" do
    plugin_info[:uri].should == @uri
  end
end

describe 'list' do
  before :all do
    @uri = GIT_PLUGIN
    @name, @plugin_folder = install_plugin(@uri)
  end

  after :all do
    `rm -rf #{@plugin_folder}`
  end

  def list_info
    `cd #{TEST_RAILS} && script/plugin list`.split("\n")[1]
  end

  it "displays meta information" do
    list_info.should =~ %r{^#{@name} #{@uri} [\da-f]+ \d\d\d\d-\d\d-\d\d \d\d:\d\d:\d\d$}
  end

  it "displays normal information when meta info is missing" do
    `rm #{@plugin_folder}/PLUGIN_INFO.yml`
    list_info.should =~ %r{^#{@name}$}
  end
end

describe 'update' do
  before :all do
    @uri = GIT_PLUGIN
    @name, @plugin_folder = install_plugin(@uri)
  end

  after :all do
    `rm -rf #{@plugin_folder}`
  end

  def info_file
    "#{@plugin_folder}/PLUGIN_INFO.yml"
  end

  def plugin_info
    YAML.load(File.read(info_file))
  end

  def change_revision(to)
    info = plugin_info
    File.open(info_file,'w'){|f| f.write info.merge(:revision => to).to_yaml }
  end

  it "does not update plugins that do not need update" do
    `cd #{TEST_RAILS} && script/plugin update #{@name}`.strip.should == "Plugin is up to date: #{@name} (#{plugin_info[:revision]})"
  end

  it "updates plugins that need update" do
    old_revision = plugin_info[:revision]
    change_revision('xxxx')
    plugin_info[:revision].should_not == old_revision

    `cd #{TEST_RAILS} && script/plugin update #{@name}`.strip.should == "Reinstalling plugin: #{@name} (xxxx)"

    plugin_info[:revision].should == old_revision
  end

  it "show 'no meta info' for plugins without info" do
    `rm #{info_file}`
    `cd #{TEST_RAILS} && script/plugin update #{@name}`.strip.should == "No meta info found: #{@name}"
  end
end

describe 'info' do
  before :all do
    @uri = GIT_PLUGIN
    @name, @plugin_folder = install_plugin(@uri)
  end

  after :all do
    `rm -rf #{@plugin_folder}`
  end

  it "shows basic info" do
    `cd #{TEST_RAILS} && script/plugin info #{@name}`.strip.should =~ /^checksum: [\da-f]+\ninstalled_at: [^\n]+\nlocally_modified: No\nrevision: [\da-f]+\nuri: #{@uri}$/m
  end

  it "shows modified if it was modified" do
    `echo 111 >> #{TEST_RAILS}/vendor/plugins/#{@name}/README.markdown`
    `cd #{TEST_RAILS} && script/plugin info #{@name}`.strip.should include('locally_modified: Yes')
  end

  it "only shows name when no info is available" do
    `rm #{TEST_RAILS}/vendor/plugins/#{@name}/PLUGIN_INFO.yml`
    `cd #{TEST_RAILS} && script/plugin info #{@name}`.strip.should == @name
  end
end

describe 'cleanup' do
  it "cleans up" do
    `rm -rf #{TEST_RAILS}`
  end
end