class BubbleStatus < ActiveRecord::Base
  belongs_to :bubble_group_status
  belongs_to :bubble

  scope :active, ->{ where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :passed, ->{ where(passed: true) }
  scope :failed, ->{ where(passed: false) }

  def predecessors(poset = nil)
    poset ||= self.bubble_group_status.current_poset
    self.bubble_group_status.bubble_statuses.where(bubble: self.bubble.predecessors(poset))
  end

  def successors(poset = nil)
    poset ||= self.bubble_group_status.current_poset
    self.bubble_group_status.bubble_statuses.where(bubble: self.bubble.successors(poset))
  end

  def downset(poset = nil)
    poset ||= self.bubble_group_status.current_poset
    self.bubble_group_status.bubble_statuses.where(bubble: self.bubble.downset(poset))
  end

  def upset(poset = nil)
    poset ||= self.bubble_group_status.current_poset
    self.bubble_group_status.bubble_statuses.where(bubble: self.bubble.upset(poset))
  end

  def reset
    self.passed = false
    self.active = false
  end

  def reset!
    self.reset
    self.save!
  end
end

