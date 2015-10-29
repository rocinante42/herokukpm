class KidActivity < ActiveRecord::Base
  belongs_to :bubble_group_status

  def total_time
    current_progress_time = bubble_group_status.active? ? Time.now - updated_at : 0
    current_progress_time + (updated_at - created_at)
  end
end
