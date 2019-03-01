class User < ApplicationRecord
  include Clearance::User

  has_many :user_tours, dependent: :delete_all
  has_many :tours, through: :user_tours
  has_many :reviews, dependent: :delete_all

  # User can have only one role
  # Default should be customer?
  ROLES = %w(customer agent admin)

  # every User must have: Email, password, role
  validates :role, presence: true

  # A User's role can be either: admin, agent, or customer
  # 'inclusion' verifies this, and %w is a word (string) array
  validates :role, inclusion: {
      :in => ROLES,
      message: "'%{value}' is not a valid role. Only options allowed are 'admin', 'agent', 'customer'"
  }

  # Clearance:: User already checks for Email uniqueness

  # If a user is not an admin, which is usually the case, make sure user has a first and last name
  validates :first_name, :last_name, presence: true, if: :user_is_not_admin?

  validates :password,
            :length => { minimum: 6 },
            :if => lambda{ new_record? || !password.nil? }

  # check if user is admin
  def user_is_not_admin?
    role != "admin"
  end

end
