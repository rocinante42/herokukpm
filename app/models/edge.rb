class Edge < ActiveRecord::Base
  belongs_to :source, class_name: 'Bubble'
  belongs_to :destination, class_name: 'Bubble'
  belongs_to :poset

  validates_presence_of :source, :destination, :poset

  scope :exiting, ->(bubble) { where(source: bubble) }
  scope :entering, ->(bubble) { where(destination: bubble) }
end
