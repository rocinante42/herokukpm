json.array!(@edges) do |edge|
  json.extract! edge, :id, :source_id, :destination_id, :poset_id
  json.url edge_url(edge, format: :json)
end
