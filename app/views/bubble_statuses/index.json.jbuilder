json.array!(@bubble_statuses) do |bubble_status|
  json.extract! bubble_status, :id, :kid_id, :bubble_id, :passed, :active
  json.url bubble_status_url(bubble_status, format: :json)
end
