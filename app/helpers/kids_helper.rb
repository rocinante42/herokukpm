module KidsHelper

  def kid_avatar_for kid
    kid.female? ? 'girl_avatar.jpg' : 'boy_avatar.png'
  end

end
