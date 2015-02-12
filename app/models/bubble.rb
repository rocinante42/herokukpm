class Bubble < ActiveRecord::Base
  require 'csv'

  belongs_to :bubble_group

  has_many :bubble_games, dependent: :destroy
  has_many :games, through: :bubble_games

  default_scope ->{ order(:bubble_group_id) }

  validates :name, uniqueness: { scope: :bubble_group_id }, presence: true

  def predecessors(poset)
    Bubble.where(id: poset.edges.entering(self).pluck(:source_id))
  end

  def successors(poset)
    Bubble.where(id: poset.edges.exiting(self).pluck(:destination_id))
  end

  def upset(poset)
    up = []

    tmp = [self.id]
    while tmp.length > 0
      up = up | tmp
      tmp = poset.edges.where(source_id: tmp).pluck(:destination_id) - up
    end

    Bubble.where(id: up)
  end

  def downset(poset)
    down = []

    tmp = [self.id]
    while tmp.length > 0
      down = down | tmp
      tmp = poset.edges.where(destination_id: tmp).pluck(:source_id) - down
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
        bubbles << Bubble.create(params)
      end
    end

    return bubbles
  end
end
