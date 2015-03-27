json.array!(@classrooms) do |classroom|
  json.partial! 'classroom', classroom: classroom
end
