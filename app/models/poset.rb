class Poset < ActiveRecord::Base
  require 'csv'

  has_many :edges, dependent: :destroy
  validates :name, length: { in: 2..35 }
  def bubble_group
    BubbleGroup.where('full_poset_id = (?) OR forward_poset_id = (?) OR backward_poset_id = (?)', self, self, self).first
  end

  def bubbles cat = nil
    Bubble.where(id: self.edges.in_category(cat).pluck(:source_id, :destination_id).flatten.uniq)
  end

  def minima cat = nil
    Bubble.where(id: self.edges.in_category(cat).pluck(:source_id).uniq - self.edges.in_category(cat).pluck(:destination_id).uniq)
  end

  def maxima cat = nil
    Bubble.where(id: self.edges.in_category(cat).pluck(:destination_id).uniq - self.edges.in_category(cat).pluck(:source_id).uniq)
  end

  def self.create_from_csv csv_file, bubbles, poset_params
    if csv_file
      poset = Poset.create(poset_params)
      CSV.foreach(csv_file.path, {headers:true}) do |row|
        src = bubbles.find_by(name: row[0])
        dst = bubbles.find_by(name: row[1])

        Edge.create(source: src, destination: dst, poset: poset)
      end

      return poset
    end
  end
end
