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
    elsif user.parent?
      can [:reports, :download_report], Kid do |kid|
        kid.parents.include? user
      end
    elsif user.teacher_admin?
      can :manage, Classroom do |cr|
        cr.school == user.school
      end
      can :create, Kid
      can :manage, Kid do |kid|
        kid.classroom.try(:school) == user.school
      end
      can :create, User
      can :manage, User do |u|
        u.classrooms.joins(:school).where(schools: {id: user.school.id}).any? if u.teacher?
        (u.kids & user.school.students).any? if u.parent?
      end
    end
    unless user.parent?
      can [:dashboard, :dashboard_classroom, :activities], User
    end
    unless user.admin?
      cannot [:index, :dashboard_admin], User
      cannot :index, BubbleCategory
      cannot :index, BubbleGame
      cannot :index, BubbleGroupStatus
      cannot :index, BubbleGroup
      cannot :index, BubbleStatus
      cannot :index, Bubble
      cannot :index, School
      cannot :index, Kid
    end
    unless user.parent?
      can [:bulk_submit, :bulk_update], Assignment
    end
  end
end
