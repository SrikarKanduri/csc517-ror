class Review < ApplicationRecord

  belongs_to :user

  validates :subject, :message, :user_id, presence: true

end
