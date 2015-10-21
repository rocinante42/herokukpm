class Trigger < ActiveRecord::Base
  require 'csv'

  attr_accessor :destination_id

  belongs_to :bubble
  belongs_to :bubble_group

  validates :bubble, :bubble_group, presence: true

  def self.create_from_csv csv_file, trigger_params = {}
    triggers = []

    if csv_file
      CSV.foreach(csv_file.path, {headers:true}) do |row|
        trigger = initialize_with_data row, trigger_params
        triggers << trigger if trigger.save
      end
    end
    triggers
  end

  def self.initialize_with_data data, trigger_params = {}
    trigger = Trigger.new
    source_bubble_group_name = data[0]
    source_bubble_name = data[1]
    dest_bubble_group_name = data[2]
    source_bubble_group = BubbleGroup.where(name: source_bubble_group_name).first
    dest_bubble_group = BubbleGroup.where(name: dest_bubble_group_name).first
    if source_bubble_group && dest_bubble_group
      source_bubble = source_bubble_group.bubbles.where(name: source_bubble_name).first
      if source_bubble
        params = trigger_params.clone
        params[:bubble] = source_bubble
        params[:bubble_group] = dest_bubble_group

        trigger.assign_attributes(params)
      end
    end
    trigger
  end
end

