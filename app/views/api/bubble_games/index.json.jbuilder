json.array!(@bubble_games) do |bubble_game|
  json.partial! 'bubble_game', bubble_game: bubble_game
end
