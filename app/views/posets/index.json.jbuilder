json.array!(@posets) do |poset|
  json.extract! poset, :id
  json.url poset_url(poset, format: :json)
end
