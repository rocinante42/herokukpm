class BubbleGroup < ActiveRecord::Base
  has_many :bubbles, dependent: :destroy
  has_many :bubble_categories, through: :bubbles
  has_and_belongs_to_many :classroom_types, join_table: 'bubble_groups_classroom_types'
  has_many :bubble_group_statuses, dependent: :destroy
  has_many :triggers, dependent: :destroy
  has_many :assignments

  belongs_to :full_poset, class_name: 'Poset'
  belongs_to :forward_poset, class_name: 'Poset'
  belongs_to :backward_poset, class_name: 'Poset'
end
