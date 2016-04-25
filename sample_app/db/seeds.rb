20.times.each do
  User.create! name: Faker::Name.name,
               birth_date: Faker::Date.backward(36500),
               mail: Faker::Internet.email
end
