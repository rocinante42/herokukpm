class PromoteBubbleGameParams < ActiveRecord::Migration
  def up
    change_column :bubble_games, :game_params, :text
    change_column :bubble_games, :scoring_params, :text
  end

  def down
    change_column :bubble_games, :game_params, :string
    change_column :bubble_games, :scoring_params, :string
  end
end
