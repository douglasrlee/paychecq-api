# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

if Client.find_by(id: '04b3969a-0008-4c99-8ee1-10c1fb4ff268').nil?
  Client.create!(
    id: '04b3969a-0008-4c99-8ee1-10c1fb4ff268',
    secret: 'a4a030c7-1940-4cb7-a58d-fdb838a10aa6',
    name: 'Postman',
    public: false
  )
end
