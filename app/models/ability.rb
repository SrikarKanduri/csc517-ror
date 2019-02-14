class Ability
  include CanCan::Ability

  def initialize(user)
    if user.role? :admin
      can :manage, :all

    elsif user.role? :agent
      can :manage, Tour

    elsif user.role? :customer
      can :manage, Tour
    end
  end
end