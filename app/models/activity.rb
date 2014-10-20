class Activity < ActiveRecord::Base
  has_many :entry_edges, foreign_key: :destination_id, class_name: 'Edge'
  has_many :exit_edges,  foreign_key: :source_id,      class_name: 'Edge'

  has_many :predecessors, through: :entry_edges, source: :source
  has_many :successors,   through: :exit_edges,  source: :destination

  has_and_belongs_to_many :games
end

