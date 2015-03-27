## def rec
rec = 1 unless local_assigns.has_key? :rec

## rec check
if rec == 0
  json.extract! edge, :id
else
  ## simple attrs
  json.extract! edge, :id

  ## relationships
  json.source do
    json.partial! 'bubbles/bubble', bubble: edge.source, rec: (rec - 1)
  end
  json.destination do
    json.partial! 'bubbles/bubble', bubble: edge.destination, rec: (rec - 1)
  end
end

