# Create our admin user
User.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password', role: 'admin')

# Create a test user and give them an address
user = User.create!(email: 'test@test.com', password: 'password', password_confirmation: 'password')
Address.create!(user_id: user.id, zip_code: '30324')


# Go ahead and seed a few restaurants
RESTAURANTS = ['Subway', 'Chik-fil-a', 'McDonalds']

RESTAURANTS.each do |restaurant|
  Restaurant.create!(name: restaurant)
end