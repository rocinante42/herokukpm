class BubbleStatus < ActiveRecord::Base
  belongs_to :bubble_group_status
  belongs_to :bubble

  scope :active, ->{ where(active: true) }
  scope :passed, ->{ where(passed: true) }

  def predecessors
    self.bubble_group_status.bubble_statuses.where(bubble: self.bubble.predecessors(self.bubble_group_status.current_poset))
  end

  def successors
    self.bubble_group_status.bubble_statuses.where(bubble: self.bubble.successors(self.bubble_group_status.current_poset))
  end
end

