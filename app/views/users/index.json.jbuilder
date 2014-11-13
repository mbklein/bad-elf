json.array!(@users) do |user|
  json.extract! user, :id, :name, :email, :avatar, :address
  json.url user_url(user, format: :json)
end
