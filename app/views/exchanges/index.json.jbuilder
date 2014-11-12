json.array!(@exchanges) do |exchange|
  json.extract! exchange, :id, :name, :description, :deadline, :owner_id
  json.url exchange_url(exchange, format: :json)
end
