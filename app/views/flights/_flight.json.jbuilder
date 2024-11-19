json.extract! flight, :id, :scheduled_at, :user_id, :completed, :total_hours, :created_at, :updated_at
json.url flight_url(flight, format: :json)
