json.array!(@triggers) do |trigger|
  json.extract! trigger, :id, :source_id, :destination_id, :poset_id
  json.url trigger_url(trigger, format: :json)
end
