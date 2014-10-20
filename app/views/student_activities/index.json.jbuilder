json.array!(@student_activities) do |student_activity|
  json.extract! student_activity, :id, :status, :score, :active, :poset_id, :activity_id, :game_id
  json.url student_activity_url(student_activity, format: :json)
end
