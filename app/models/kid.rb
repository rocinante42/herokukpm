class Kid < ActiveRecord::Base
  belongs_to :classroom

  has_many :bubble_group_statuses, dependent: :destroy
  has_many :bubble_statuses, dependent: :destroy

  def full_name
    "#{self.first_name} #{self.last_name}"
  end
end
