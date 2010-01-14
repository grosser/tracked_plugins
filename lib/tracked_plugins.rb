require 'old_script_plugin'

# get alias_method_chain
require 'active_support/core_ext/array'
require 'active_support/core_ext/module'

# .to_s(:db)
require 'active_support/core_ext/time'

# remove everything we no longer need
[:List, :Update, :Discover, :Unsource, :Sources, :Info].each{|c| Commands.send(:remove_const,c)}

require 'tracked_plugins/plugin'
require 'tracked_plugins/commands/base'
require 'tracked_plugins/commands/list'
require 'tracked_plugins/commands/info'
require 'tracked_plugins/commands/update'
require 'tracked_plugins/rails_environment'

Commands::Plugin.parse!