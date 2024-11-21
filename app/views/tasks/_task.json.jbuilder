json.extract! task, :id, :name, :acs_code, :description, :category, :created_at, :updated_at
json.url task_url(task, format: :json)
