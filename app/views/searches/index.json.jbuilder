json.array!(@searches) do |search|
  json.extract! search, :id, :q
  json.url search_url(search, format: :json)
end
