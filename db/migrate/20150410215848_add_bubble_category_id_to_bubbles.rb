class AddBubbleCategoryIdToBubbles < ActiveRecord::Migration
  def change
    add_reference :bubbles, :bubble_category, index: true
  end
end
