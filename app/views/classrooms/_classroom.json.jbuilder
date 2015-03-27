## def rec
rec = 1 unless local_assigns.has_key? :rec

## rec check
if rec == 0
  json.extract! classroom, :id
else
  ## simple attrs
  json.extract! classroom, :id, :name

  ## relationships
  json.partial! 'schools/school', school: classroom.school, rec: (rec - 1)
end

