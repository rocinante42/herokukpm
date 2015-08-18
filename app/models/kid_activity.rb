class KidActivity < ActiveRecord::Base
  belongs_to :assignment

  def total_time
    updated_at - created_at
  end
end
