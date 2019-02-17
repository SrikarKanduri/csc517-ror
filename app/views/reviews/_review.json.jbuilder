json.extract! review, :id, :subject, :message, :created_at, :updated_at
json.url review_url(review, format: :json)
