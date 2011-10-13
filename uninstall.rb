code = <<-EOF
#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/../config/boot'
require 'commands/plugin'
EOF

file = "script/plugin"
if File.exist?(file)
  File.open(file, 'w'){|f| f.write code }
elsif File.exist?('script/rails')
  lines = File.readlines('script/rails').reject{|l| l.include?('tracked_plugins') }
  File.open('script/rails','w'){|f| f.write lines.join }
else
  puts "could not find script/plugin, put this in yourself!!!"
  puts code
end
