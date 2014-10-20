class Edge < ActiveRecord::Base
  belongs_to :source, class_name: 'Activity'
  belongs_to :destination, class_name: 'Activity'
  belongs_to :poset
end

