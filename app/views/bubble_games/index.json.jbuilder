json.array!(@bubble_games) do |bubble_game|
  json.extract! bubble_game, :id, :bubble_id, :game_id, :skin, :game_params, :scoring_params
  json.url bubble_game_url(bubble_game, format: :json)
end
