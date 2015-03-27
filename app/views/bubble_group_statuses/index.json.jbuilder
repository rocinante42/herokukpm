json.array!(@bubble_group_statuses) do |bubble_group_status|
  json.partial! 'bubble_group_status', bubble_group_status: bubble_group_status
end
