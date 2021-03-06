## def rec
rec = 1 unless local_assigns.has_key? :rec

if rec == 0
  json.extract! bubble_status, :id
else
  ## simple attrs
  json.extract! bubble_status, :id, :passed, :active

  ## relationships
  json.bubble do
    json.partial! 'api/bubbles/bubble', bubble: bubble_status.bubble, rec: (rec - 1)
  end
  json.bubble_group_status do
    json.partial! 'api/bubble_group_statuses/bubble_group_status', bubble_group_status: bubble_status.bubble_group_status, rec: (rec - 1)
  end
end

