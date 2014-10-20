class CreateActivitiesGamesJoinTable < ActiveRecord::Migration
  def change
    create_table :activities_games, :id => false do |t|
      t.integer :activity_id
      t.integer :game_id
    end
  end
end
