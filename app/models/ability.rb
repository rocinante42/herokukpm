class Ability
  include CanCan::Ability

  def initialize(user)
    if user.admin?
      can :manage, :all
    elsif user.teacher?
      ##Ability with kid
      can :create, Kid
      can :manage, Kid do |kid|
        user.students.include? kid
      end
      ##Ability with classroom
      can :create, Classroom
      can :manage, Classroom do |classroom|
        classroom.try(:teacher) == user
      end
      can :create, User
      can :manage, User do |u|
        (user.students & u.kids).any?
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
