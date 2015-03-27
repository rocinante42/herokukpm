## def rec
rec = 1 unless local_assigns.has_key? :rec

## rec check
if rec == 0
  json.extract! bubble_group, :id
else
  ## simple attrs
  json.extract! bubble_group, :id, :name, :description

  ## relationships
  json.full_poset do
    json.partial! 'posets/poset', poset: bubble_group.full_poset, rec: (rec - 1)
  end
  json.forward_poset do
    json.partial! 'posets/poset', poset: bubble_group.forward_poset, rec: (rec - 1)
  end
  json.backward_poset do
    json.partial! 'posets/poset', poset: bubble_group.backward_poset, rec: (rec - 1)
  end
end

