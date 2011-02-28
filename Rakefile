task :default do
  sh "rspec spec"
end

task :rails2 do
  sh "cd spec/rails2 && RAILS=rails rspec ../../spec"
end

task :all do
  sh "rake && rake rails2"
end
