rec = 1 unless local_assigns.has_key? :rec

if rec == 0
  json.extract! school, :id
else
  json.extract! school, :id, :name
  json.kids do
    json.array!(school.students) do |kid|
      json.partial! 'api/kids/kid', kid: kid, rec: rec
    end
  end
end

