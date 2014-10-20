json.array!(@students) do |student|
  json.extract! student, :id, :first_name, :last_name, :age, :location, :primary_language, :game_language, :first_time, :classroom_id
  json.url student_url(student, format: :json)
end
