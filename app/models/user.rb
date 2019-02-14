class User < ApplicationRecord
  include Clearance::User

  # has_one :agent
  # has_one :customer
  has_many :tours

  # User can have only one role
  ROLES = %w[admin agent customer].freeze

  # generate symbol list
  def role_symbols
    [role.to_sym]
  end
  validates :email, uniqueness: true

  # make every User (Admin, Agent, Customer) have a name
  validates :name, presence: true
end
