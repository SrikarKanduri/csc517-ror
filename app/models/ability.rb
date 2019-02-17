class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.role? :admin
      can :manage, :all

    elsif user.role? :agent
      can :manage, Tour
      can :view, Review

    elsif user.role? :customer
      can :view, Tour
      can :search, Tour
      can :bookmark, Tour
      can :book, Tour
      can :manage, Review
    end
  end
end