desc 'Unassign inactive kids'
task :unassign_inactive_kids => :environment do 
  inactive_kids = Kid.all.select(&:has_expired_token?)
  Assignment.where(kid_id: inactive_kids.map(&:id)).update_all(status: Assignment::NONE)
end
