class User < ApplicationRecord
  include Clearance::User

  has_one :agent
  has_one :customer

  validates :email, uniqueness: true

end
