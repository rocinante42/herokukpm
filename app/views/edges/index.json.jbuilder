json.array!(@edges) do |edge|
  json.partial! 'edge', edge: edge
end
