class Ability
  include CanCan::Ability

  def initialize(user)
    if user.admin?
      can :manage, :all
    elsif user.teacher?
      can :read, Kid
      can :create, Kid
      can :update, Kid do |kid|
        kid.try(:user) == user
      end
      can :destroy, Kid do |kid|
        kid.try(:user) == user
      end
      can :read, Classroom
      can :read, BubbleCategory
      can :read, BubbleGame
      can :read, BubbleGroupStatus
      can :read, BubbleGroup
      can :read, BubbleStatus
      can :read, Bubble
    end
  end
end
