json.array!(@bubble_games) do |bubble_game|
  json.partial! 'bubble_games/bubble_game', bubble_game: bubble_game, rec: 2
end

