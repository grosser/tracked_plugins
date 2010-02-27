rails_2 = <<-EOF
#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/../config/boot'
$LOAD_PATH << 'vendor/plugins/tracked_plugins/lib'
require 'vendor/plugins/tracked_plugins/lib/tracked_plugins'
EOF

rails_3 = "$LOAD_PATH.unshift( File.expand_path('../../vendor/plugins/tracked_plugins/lib',  __FILE__) )\n"

if File.exist?('script/plugin') # rails 2
  # install script/plugin hook
  File.open('script/plugin', 'w'){|f| f.write rails_2 }
elsif File.exist?('script/rails') # rails 3
  # install script/rails hook
  lines = File.readlines('script/rails').map do |line|
    if line.include?('plugins/tracked_plugins')
      nil # remove old installation
    elsif line.strip == 'require BOOT_PATH'
      [line, rails_3] # add hook after this line
    else
      line
    end
  end
  File.open('script/rails','w'){|f| f.write lines.compact.flatten.join }
else
  # instruct user to DIY
  puts "could not find script/plugin or script/rails, put this in yourself!!!"
  puts "Rails 2: put this into script/plugin"
  puts rails_2
  puts ""
  puts "Rails 3: add after 'require BOOT_PATH' in script/rails"
  puts rails_3
end