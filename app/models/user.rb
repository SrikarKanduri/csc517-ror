class User < ApplicationRecord
  include Clearance::User

  has_many :user_tours
  has_many :tours, through: :user_tours

  # User can have only one role
  ROLES = %w[admin agent customer].freeze

  # generate symbol list
  def role_symbols
    [role.to_sym]
  end

  validates :email, uniqueness: true
end
