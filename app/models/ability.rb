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
      can :bookmark, Tour, :users => { :id => user.id }
      can :undo_bookmark, Tour, :users => { :id => user.id }
      can :book, Tour, :users => { :id => user.id }
      can :update_booking, Tour, :users => { :id => user.id }
      can :read, Review
      can :manage, Review, :user_id => user.id
    end
  end
end