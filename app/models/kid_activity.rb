class KidActivity < ActiveRecord::Base
  belongs_to :assignment

  def total_time
    current_progress_time = assignment.active? ? Time.now - updated_at : 0
    current_progress_time + (updated_at - created_at)
  end
end
