## def rec
rec = 1 unless local_assigns.has_key? :rec

## rec check
if rec == 0
  json.extract! poset, :id
else
  json.extract! poset, :id, :name, :pass_threshold, :fail_threshold
end

