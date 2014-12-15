class Poset < ActiveRecord::Base
  require 'csv'

  has_many :edges

  def bubble_group
    BubbleGroup.where('full_poset_id = (?) OR forward_poset_id = (?) OR backward_poset_id = (?)', self, self, self).first
  end

  def bubbles
    Bubble.where(id: self.edges.pluck(:source_id, :destination_id).flatten.uniq)
  end

  def minima
    Bubble.where(id: self.edges.pluck(:source_id).uniq - self.edges.pluck(:destination_id).uniq)
  end

  def maxima
    Bubble.where(id: self.edges.pluck(:destination_id).uniq - self.edges.pluck(:source_id).uniq)
  end

  def self.create_from_csv csv_file, poset_params
    if csv_file
      poset = Poset.create(poset_params)
      CSV.foreach(csv_file.path, {headers:true}) do |row|
        src = Bubble.find_by(name: row[0])
        dst = Bubble.find_by(name: row[1])

        Edge.create(source: src, destination: dst, poset: poset)
      end

      return poset
    end
  end
end
