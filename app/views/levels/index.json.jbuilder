json.array!(@levels) do |level|
  json.extract! level, :id, :key, :name
  json.url level_url(level, format: :json)
end
