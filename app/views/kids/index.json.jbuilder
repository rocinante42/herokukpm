json.array!(@kids) do |kid|
  json.extract! kid, :id, :login_id, :classroom_id
  json.url kid_url(kid, format: :json)
end
