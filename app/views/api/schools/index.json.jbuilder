json.array!(@schools) do |school|
  json.partial! 'school', school: school
end
