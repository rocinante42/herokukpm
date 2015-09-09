## recurse check
rec = 1 unless local_assigns.has_key? :rec

if rec == 0
  json.extract! bubble_game, :id
else
  ## parse json fields, if possible
  gp = bubble_game.game_params
  sp = bubble_game.scoring_params
  begin
    gp = JSON.parse gp
  rescue
  end
  begin
    sp = JSON.parse sp
  rescue
  end

  ## extract general params
  json.extract! bubble_game, :id, :skin
  json.game_params gp
  json.scoring_params sp

  ## extract relationships
  json.bubble do
    json.partial! 'api/bubbles/bubble', bubble: bubble_game.bubble, rec: (rec - 1)
  end
  json.game do
    json.partial! 'api/games/game', game: bubble_game.game, rec: (rec - 1)
  end
end

