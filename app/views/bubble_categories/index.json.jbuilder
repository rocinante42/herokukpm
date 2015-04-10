json.array!(@bubble_categories) do |bubble_category|
  json.extract! bubble_category, :id, :name
  json.url bubble_category_url(bubble_category, format: :json)
end
