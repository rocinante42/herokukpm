json.array!(@bubble_groups) do |bubble_group|
  json.partial! 'bubble_group', bubble_group: bubble_group
end
