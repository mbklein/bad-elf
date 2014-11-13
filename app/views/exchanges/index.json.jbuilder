json.array!(@exchanges) do |exchange|
  json.extract! exchange, :id, :name, :description, :deadline, :owner_id, :invite_code
  json.url exchange_url(exchange, format: :json)
end
