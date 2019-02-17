class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.role.eql? "admin"
      can :manage, :all

    elsif user.role.eql? "agent"
      can [:read, :create], Tour
      can :manage, Tour, :users => { :id => user.id }
      can :read, Review

    elsif user.role.eql? "customer"
      can :read, Tour
      can :search, Tour
      can :bookmark, Tour
      can :book, Tour
      can :manage, Review
    end
  end
end