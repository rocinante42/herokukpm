desc 'Clear expired time limit assignments'
task :clear_expired_time_limit_assignments => :environment do
  exceeded_bg_statuses = BubbleGroupStatus.all.select(&:expired?)
  exceeded_bg_statuses.update_all(active: BubbleGroupStatus::ACTIVE_NONE)
end