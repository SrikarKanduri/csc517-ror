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
      can :undo_bookmark, Tour
      can :book, Tour
      can :update_booking, Tour
      can [:read, :create], Review
      can :manage, Review, :user_id => user.id
    end
  end
end