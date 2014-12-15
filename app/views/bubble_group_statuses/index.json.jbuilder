json.array!(@bubble_group_statuses) do |bubble_group_status|
  json.extract! bubble_group_status, :id, :kid_id, :bubble_group_id, :poset_id, :pass_counter, :fail_counter
  json.url bubble_group_status_url(bubble_group_status, format: :json)
end
