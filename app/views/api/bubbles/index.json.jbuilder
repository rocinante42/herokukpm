json.array!(@bubbles) do |bubble|
  json.partial! 'bubble', bubble: bubble
end
