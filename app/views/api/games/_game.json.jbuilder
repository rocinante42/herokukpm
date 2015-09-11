rec = 1 unless local_assigns.has_key? :rec

if rec == 0
  json.extract! game, :id
else
  json.extract! game, :id, :name, :description
end

