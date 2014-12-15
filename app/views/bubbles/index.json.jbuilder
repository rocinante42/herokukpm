json.array!(@bubbles) do |bubble|
  json.extract! bubble, :id, :name, :description, :bubble_group_id
  json.url bubble_url(bubble, format: :json)
end
