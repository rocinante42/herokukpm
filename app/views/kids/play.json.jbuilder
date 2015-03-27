if @bubble_group
  json.bubble do
    json.partial! 'bubbles/bubble', bubble: @bubble_status.bubble, rec: 1
  end
else
  json.error "Select a bubble group"
end

