task :default => :spec
require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = '--backtrace --color'
end

task :all_rails do
  puts `RAILS=/usr/local/lib/ruby/gems/1.8/gems/rails-2.3.5/bin/rails ; rake`
  puts `RAILS=/usr/local/lib/ruby/gems/1.8/gems/railties-3.0.0.beta/bin/rails ; rake`
end
