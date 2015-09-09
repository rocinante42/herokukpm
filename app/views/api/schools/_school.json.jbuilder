rec = 1 unless local_assigns.has_key? :rec

if rec == 0
  json.extract! school, :id
else
  json.extract! school, :id, :name
end

