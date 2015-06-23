class Trigger < ActiveRecord::Base
  require 'csv'

  belongs_to :bubble
  belongs_to :bubble_group

  validates :bubble, :bubble_group, presence: true

  def self.create_from_csv csv_file, trigger_params = {}
    triggers = []

    if csv_file
      CSV.foreach(csv_file.path, {headers:true}) do |row|
        source_bubble_group_name = row[0]
        source_bubble_name = row[1]
        dest_bubble_group_name = row[2]

        source_bubble_group = BubbleGroup.where(name: source_bubble_group_name).first
        dest_bubble_group = BubbleGroup.where(name: dest_bubble_group_name).first
        if source_bubble_group && dest_bubble_group
          source_bubble = source_bubble_group.bubbles.where(name: source_bubble_name).first
          if source_bubble
            params = trigger_params.clone
            params[:bubble] = source_bubble
            params[:bubble_group] = dest_bubble_group

            trigger = Trigger.create(params)
            if trigger
              triggers << trigger
            end
          end
        end
      end
    end

    return triggers
  end
end

