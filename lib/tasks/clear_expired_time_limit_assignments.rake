desc 'Clear expired time limit assignments'
task :clear_expired_time_limit_assignments => :environment do
  exceeded_assignments = Assignment.all.select(&:expired?)
  exceeded_assignments.each do |assignment|
    assignment.update(status: Assignment::PASSED) unless assignment.passed?
  end
end