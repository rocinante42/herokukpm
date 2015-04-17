class BubbleCategory < ActiveRecord::Base
  has_many :bubbles, dependent: :nullify

  def self.create_from_csv csv_file, options = {}
    bubble_categories = []

    ## restrict the search spaces
    bubbles = options[:bubble_group].try(:bubbles) || Bubble
    categories = BubbleCategory

    ## parse the file
    if csv_file
      CSV.foreach(csv_file.path, {headers: true}) do |row|
        ## extract column info
        category_name = row[0]
        bubble_name = row[1]

        ## find the bubble
        bubble = bubbles.where(name: bubble_name).first
        category = categories.find_or_create_by(name: category_name)

        ## update the bubble, if possible
        bubble.update(bubble_category_id: category.id) if bubble

        ## save the category for later
        bubble_categories << category
      end
    end

    ## return unique categories
    return bubble_categories.uniq
  end
end
