# frozen_string_literal: true

FactoryBot.define do
  factory :client do
    secret { 'a4a030c7-1940-4cb7-a58d-fdb838a10aa6' }
    name { Faker::Name.unique.name }
    public { false }
  end
end
