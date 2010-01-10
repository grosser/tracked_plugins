code = <<-EOF
#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/../config/boot'
require 'vendor/plugins/useful_script_plugin/lib/useful_script_plugin'
EOF

file = "script/plugin"
if File.exist?(file)
  File.open(file, 'w'){|f| f.write code }
else
  puts "could not find script/plugin, put this in yourself!!!"
  puts code
end