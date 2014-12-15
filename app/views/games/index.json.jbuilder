json.array!(@games) do |game|
  json.extract! game, :id, :name, :description
  json.url game_url(game, format: :json)
end
