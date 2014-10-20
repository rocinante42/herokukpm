json.array!(@posets) do |poset|
  json.extract! poset, :id, :name
  json.url poset_url(poset, format: :json)
end
