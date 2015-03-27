json.array!(@kids) do |kid|
  json.partial! 'kid', kid: kid
end
