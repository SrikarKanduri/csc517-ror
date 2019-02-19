class Review < ApplicationRecord

  belongs_to :user
  belongs_to :tour

  validates :subject, :message, :user_id, :tour_id, presence: true

end
