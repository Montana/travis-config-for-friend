require 'rubygems'
require 'cucumber'
require 'cucumber/rake/task'

desc 'Execute Buyer features'
task :buyer_features, [:apk_path] do |_task, args|
  puts 'Running Buyer features'
  sh "bundle exec calabash-android run #{args[:apk_path]} -p android features/ -t ~@seller -f html -o reports/buyer/buyer.html"
end

desc 'Execute Seller features'
task :seller_features, [:apk_path] do |_task, args|
  puts 'Running Seller features'
  sh "bundle exec calabash-android run #{args[:apk_path]} -p android features/ -t ~@buyer -f html -o reports/seller/seller.html"
end

desc 'Execute buyer critical scenarios'
task :critical_buyer_scenarios, [:apk_path] do |_task, args|
  puts 'Running buyer critical scenarios'
  sh "bundle exec calabash-android run #{args[:apk_path]} -p android features/ -t ~@seller -t @critic_scenario -f html -o reports/buyer/critic_buyer_scenarios.html"
end

desc 'Execute seller critical scenarios'
task :critical_seller_scenarios, [:apk_path] do |_task, args|
  puts 'Running seller critical scenarios'
  sh "bundle exec calabash-android run #{args[:apk_path]} -p android features/ -t ~@buyer -t @critic_scenario -f html -o reports/seller/critic_seller_scenarios.html"
end

desc 'Start Emulator'
task :start_emulator, [:emulator_name] do |_task, args|
  puts "Starting emulator #{args[:emulator_name]}"
  sh "emulator -avd #{args[:emulator_name]} > /dev/null &"
end

desc 'Smoke suit'
task :smoke_suit, [:apk_path] do |_task, args|
  puts 'Running smoke suit'
  sh "bundle exec calabash-android run #{args[:apk_path]} -p android features/ -t @smoke"
end

desc 'Build Android project'
task :build_android, [:assemble] do |_task, args|
  puts "Building #{args[:assemble]}"

  Dir.chdir('../android')

  sh 'git checkout develop'
  sh 'git pull origin develop'
  sh "./gradlew #{args[:assemble]}"

  Dir.chdir('../specs')
end
