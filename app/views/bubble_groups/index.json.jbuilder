json.array!(@bubble_groups) do |bubble_group|
  json.extract! bubble_group, :id, :name, :description, :full_poset_id, :forward_poset_id, :backward_poset_id
  json.url bubble_group_url(bubble_group, format: :json)
end
