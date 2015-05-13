json.array!(@games_hash.keys) do |game|
  json.partial! 'games/game', game: game
end

