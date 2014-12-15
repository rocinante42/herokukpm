class BubbleGroup < ActiveRecord::Base
  has_many :bubbles

  belongs_to :full_poset, class_name: 'Poset'
  belongs_to :forward_poset, class_name: 'Poset'
  belongs_to :backward_poset, class_name: 'Poset'
end
