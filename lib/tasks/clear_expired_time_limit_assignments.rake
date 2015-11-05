desc 'Clear expired time limit assignments'
task :clear_expired_time_limit_assignments => :environment do
  exceeded_bg_statuses = BubbleGroupStatus.general.active.select(&:expired?)
  exceeded_bg_statuses.each do |bg_status|
    bg_status.reset!
    bg_status.update_attribute(:active, BubbleGroupStatus::ACTIVE_NONE)
  end
end