json.array!(@games_hash.keys) do |game|
  json.partial! 'api/games/game', game: game
end

