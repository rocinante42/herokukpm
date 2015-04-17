class BubbleGroup < ActiveRecord::Base
  has_many :bubbles, dependent: :destroy
  has_many :bubble_group_statuses, dependent: :destroy

  belongs_to :full_poset, class_name: 'Poset'
  belongs_to :forward_poset, class_name: 'Poset'
  belongs_to :backward_poset, class_name: 'Poset'
end
