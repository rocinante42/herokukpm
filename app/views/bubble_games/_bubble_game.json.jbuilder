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

json.extract! bubble_game, :bubble_id, :game_id, :skin
json.game_params gp
json.scoring_params sp

