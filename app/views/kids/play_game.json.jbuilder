if @bubble_game
  json.bubble_game do
    json.partial! 'bubble_games/bubble_game', bubble_game: @bubble_game, rec: 2
  end
else
  json.error "You have no more games to play"
end

