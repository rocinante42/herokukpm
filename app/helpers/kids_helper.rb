module KidsHelper

  def kid_avatar_for(kid:, size:)
    gender = kid.female? ? 'female' : 'male'
    "#{gender}_avatar_#{size}.png"
  end

end
