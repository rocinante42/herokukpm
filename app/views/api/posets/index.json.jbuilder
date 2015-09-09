json.array!(@posets) do |poset|
  json.partial! 'poset', poset: poset
end
