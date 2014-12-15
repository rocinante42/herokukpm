class BubbleGroupStatus < ActiveRecord::Base
  belongs_to :kid
  belongs_to :bubble_group
  belongs_to :poset

  has_many :bubble_statuses, dependent: :destroy

  alias :current_poset :poset

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
end
