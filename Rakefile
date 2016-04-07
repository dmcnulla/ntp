require 'bundler/gem_tasks'
require 'cucumber/rake/task'
require 'coveralls/rake/task'

Cucumber::Rake::Task.new(:features) do |t|
  t.profile = 'default'
end

Coveralls::RakeTask.new

task default: [:features, 'coveralls:push']
