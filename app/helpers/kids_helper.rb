module KidsHelper

  def kid_avatar_for(kid:, size:)
    gender = kid.female? ? 'female' : 'male'
    kid.female? ? "#{gender}_avatar_#{size}.png" : "#{gender}_avatar_#{size}.png"
  end

end
