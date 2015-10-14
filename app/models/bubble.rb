class Bubble < ActiveRecord::Base
  require 'csv'

  belongs_to :bubble_group
  belongs_to :bubble_category

  has_many :bubble_games, dependent: :destroy
  has_many :games, through: :bubble_games
  has_many :triggers, dependent: :destroy
  has_many :bubble_statuses

  default_scope ->{ order(:bubble_group_id) }

  validates :name, uniqueness: { scope: :bubble_group_id }, presence: true

  scope :in_category, ->(cat) { cat ? where(bubble_category_id: cat) : all }

  def predecessors(poset, cat = nil)
    Bubble.where(id: poset.edges.entering(self).in_category(cat).pluck(:source_id))
  end

  def successors(poset, cat = nil)
    Bubble.where(id: poset.edges.exiting(self).in_category(cat).pluck(:destination_id))
  end

  def upset(poset, cat = nil)
    up = []

    tmp = [self.id]
    while tmp.length > 0
      up = up | tmp
      tmp = poset.edges.in_category(cat).where(source_id: tmp).pluck(:destination_id) - up
    end

    Bubble.where(id: up)
  end

  def downset(poset, cat = nil)
    down = []

    tmp = [self.id]
    while tmp.length > 0
      down = down | tmp
      tmp = poset.edges.in_category(cat).where(destination_id: tmp).pluck(:source_id) - down
    end

    Bubble.where(id: down)
  end

  def self.create_from_csv csv_file, bubble_params = {}
    bubbles = []

    if csv_file
      CSV.foreach(csv_file.path, {headers:true}) do |row|
        params = bubble_params.clone
        params[:name] = row[0]
        params[:description] = row[1]
        category_name = row[2]

        unless category_name.blank?
          category = BubbleCategory.find_or_create_by(name: category_name)
          params[:bubble_category_id] = category.id
        end

        bubbles << Bubble.create(params)
      end
    end

    return bubbles
  end
end
