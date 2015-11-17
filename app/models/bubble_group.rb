class BubbleGroup < ActiveRecord::Base
  has_many :bubbles, dependent: :destroy
  has_many :bubble_categories, through: :bubbles
  has_many :bubble_games, through: :bubbles
  has_and_belongs_to_many :classroom_types
  has_many :bubble_group_statuses, dependent: :destroy
  has_many :triggers, dependent: :destroy

  belongs_to :full_poset, class_name: 'Poset'
  belongs_to :forward_poset, class_name: 'Poset'
  belongs_to :backward_poset, class_name: 'Poset'
  validates :name, length: {maximum: 50 }
  validates :description, length: { maximum: 255 }
  def acronym
    name.split.map{|w| w.to_i > 0 ? w : w.first }.join
  end

end
