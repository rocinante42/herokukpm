## def rec
rec = 1 unless local_assigns.has_key? :rec

## rec check
if rec == 0
  json.extract! kid, :id
else
  ## simple attrs
  json.extract! kid, :id, :first_name, :last_name, :primary_language

  ## relationships
  if kid.classroom
    json.classroom do
      json.partial! 'api/classrooms/classroom', classroom: kid.classroom, rec: (rec - 1)
    end
  end
end

