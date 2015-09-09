if @bubble_group
  json.bubble_status do
    json.partial! 'api/bubble_statuses/bubble_status', bubble_status: @bubble_status, rec: 2
  end
else
  json.error "Select a bubble group"
end

