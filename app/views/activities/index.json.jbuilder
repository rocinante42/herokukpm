json.array!(@activities) do |activity|
  json.extract! activity, :id, :name, :level, :enjoy_score, :complete_score, :pass_counter, :fail_counter, :weight, :max_level
  json.url activity_url(activity, format: :json)
end
