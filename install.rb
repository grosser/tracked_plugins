code = <<-EOF
#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/../config/boot'
$LOAD_PATH << 'vendor/plugins/tracked_plugins/lib'
require 'vendor/plugins/tracked_plugins/lib/tracked_plugins'
EOF

file = "script/plugin"
if File.exist?(file)
  File.open(file, 'w'){|f| f.write code }
else
  puts "could not find script/plugin, put this in yourself!!!"
  puts code
end