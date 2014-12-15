class CreateBubbleGames < ActiveRecord::Migration
  def change
    create_table :bubble_games do |t|
      t.integer :bubble_id
      t.integer :game_id
      t.string :skin
      t.string :game_params
      t.string :scoring_params

      t.timestamps
    end
  end
end
