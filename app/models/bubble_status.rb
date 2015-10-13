class BubbleStatus < ActiveRecord::Base
  belongs_to :bubble_group_status
  belongs_to :bubble

  scope :active, ->{ where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :passed, ->{ where(passed: true) }
  scope :failed, ->{ where(passed: false) }

  def predecessors(poset = nil, cat = nil)
    poset ||= self.bubble_group_status.current_poset
    self.bubble_group_status.bubble_statuses.where(bubble: self.bubble.predecessors(poset, cat))
  end

  def successors(poset = nil, cat = nil)
    poset ||= self.bubble_group_status.current_poset
    self.bubble_group_status.bubble_statuses.where(bubble: self.bubble.successors(poset, cat))
  end

  def downset(poset = nil, cat = nil)
    poset ||= self.bubble_group_status.current_poset
    self.bubble_group_status.bubble_statuses.where(bubble: self.bubble.downset(poset, cat))
  end

  def upset(poset = nil, cat = nil)
    poset ||= self.bubble_group_status.current_poset
    self.bubble_group_status.bubble_statuses.where(bubble: self.bubble.upset(poset, cat))
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

