json.array!(@assignments) do |assignment|
  json.extract! assignment, :id, :kid_id, :bubble_group_id, :status
  json.url assignment_url(assignment, format: :json)
end
