json.array!(@bubble_statuses) do |bubble_status|
  json.partial! 'bubble_status', bubble_status: bubble_status
end
