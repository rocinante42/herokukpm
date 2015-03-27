## set rec default
rec = 1 unless local_assigns.has_key? :rec

## check rec
if rec == 0
  json.extract! bubble_group_status, :id
else
  ## simple attrs
  json.extract! bubble_group_status, :id, :pass_counter, :fail_counter, :active

  ## relationships
  json.kid do
    json.partial! 'kids/kid', kid: bubble_group_status.kid, rec: (rec - 1)
  end
  json.bubble_group do
    json.partial! 'bubble_groups/bubble_group', bubble_group: bubble_group_status.bubble_group, rec: (rec - 1)
  end
  json.poset do
    json.partial! 'posets/poset', poset: bubble_group_status.poset, rec: (rec - 1)
  end
end

