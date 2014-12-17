class BubbleGroupStatus < ActiveRecord::Base
  belongs_to :kid
  belongs_to :bubble_group
  belongs_to :poset

  has_many :bubble_statuses, dependent: :destroy

  alias :current_poset :poset

  ## accessors for information about the current poset
  def current_poset_type
    case poset_id
    when bubble_group.full_poset_id
      "Full"
    when bubble_group.forward_poset_id
      "Forward"
    when bubble_group.backward_poset_id
      "Backward"
    else
      "Unknown"
    end
  end

  def previous_poset
    case current_poset_type
    when "Full"
      bubble_group.backward_poset
    when "Forward"
      bubble_group.full_poset
    when "Backward"
      bubble_group.backward_poset
    else
      nil
    end
  end

  def next_poset
    case current_poset_type
    when "Full"
      bubble_group.forward_poset
    when "Forward"
      bubble_group.forward_poset
    when "Backward"
      bubble_group.full_poset
    else
      nil
    end
  end

  ## sets up the statuses on all bubbles for the bubble group
  def reset!
    ## this should all be done in a single transaction, since we should do everything or nothing
    ActiveRecord::Base.transaction do
      ## reset the counters and the poset
      self.pass_counter = 0
      self.fail_counter = 0
      self.poset = self.bubble_group.forward_poset
      self.save!

      ## reset the bubble statuses for each bubble
      self.bubble_group.bubbles.each do |bubble|
        status = self.bubble_statuses.find_or_initialize_by(bubble: bubble)
        status.reset
        status.save!
      end

      ## activate the minima
      self.poset.minima.each do |bubble|
        status = self.bubble_statuses.find_by(bubble: bubble)
        status.active = true
        status.save!
      end
    end 
  end
end
