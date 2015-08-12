class Ability
  include CanCan::Ability

  def initialize(user)
    if user.admin?
      can :manage, :all
    elsif user.teacher?
      ##Ability with kid
      can :read, Kid
      can :create, Kid
      can :update, Kid do |kid|
        kid.try(:user) == user
      end
      can :destroy, Kid do |kid|
        kid.try(:user) == user
      end
      ##Ability with classroom
      can :read, Classroom
      can :create, Classroom
      can :update, Classroom do |classroom|
        classroom.try(:user) == user
      end
      can :destroy, Classroom do |classroom|
        classroom.try(:user) == user
      end
      ##Others ability with classroom
      can :read, BubbleCategory
      can :read, BubbleGame
      can :read, BubbleGroupStatus
      can :read, BubbleGroup
      can :read, BubbleStatus
      can :read, Bubble
      can :read, School
    end
  end
end
