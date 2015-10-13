class Edge < ActiveRecord::Base
  belongs_to :source, class_name: 'Bubble'
  belongs_to :destination, class_name: 'Bubble'
  belongs_to :poset

  validates_presence_of :source, :destination, :poset

  scope :exiting, ->(bubble) { where(source: bubble) }
  scope :entering, ->(bubble) { where(destination: bubble) }

  scope :in_category, ->(cat = nil) { cat ? joins('INNER JOIN "bubbles" "sources" ON "sources"."id" = "edges"."source_id" INNER JOIN "bubbles" "destinations" ON "destinations"."id" = "edges"."destination_id"')
                                              .where(sources: {bubble_category_id: cat}, destinations: {bubble_category_id: cat}) : all }

end
