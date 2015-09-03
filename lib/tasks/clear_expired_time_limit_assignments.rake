desc 'Clear expired time limit assignments'
task :clear_expired_time_limit_assignments => :environment do
  exceeded_assignments = Assignment.all.select(&:expired?)
  exceeded_assignments.update_all(status: Assignment::NONE)
end