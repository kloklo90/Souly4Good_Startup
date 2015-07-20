json.array!(@progresses) do |progress|
  json.extract! progress, :id, :level_key, :current_value, :users_id
  json.url progress_url(progress, format: :json)
end
