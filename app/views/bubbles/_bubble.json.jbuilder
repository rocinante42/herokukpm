## def rec check
rec = 1 unless local_assigns.has_key? :rec

## rec check
if rec == 0
  json.extract! bubble, :id
else
  ## simple attrs
  json.extract! bubble, :id, :name, :description

  ## relationships
  json.bubble_group do
    json.partial! 'bubble_groups/bubble_group', bubble_group: bubble.bubble_group, rec: (rec - 1)
  end
end

