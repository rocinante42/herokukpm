require 'clockwork'
require './config/boot'
require './config/environment'
require 'rake'

Rake::Task.clear
KidsPlay::Application.load_tasks

module Clockwork
  handler do |task|
    puts "Running #{task}"
  end

  every(5.minutes, 'Running clear_expired_time_limit_assignments task', tz: 'UTC') do
    Rake::Task['clear_expired_time_limit_assignments'].invoke
  end
  every(1.minute, 'Running unassign_inactive_kids task', tz: 'UTC') do
    Rake::Task['unassign_inactive_kids'].invoke
  end
end