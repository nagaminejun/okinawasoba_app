# coding: utf-8

User.create!(name:"管理者",
              email: "sample@email.com",
              password: "password",
              password_confirmation: "password",
              admin: true
              )
7.times do |n|
    name  = Faker::Name.name
    email = "sample-#{n+1}@email.com"
    password = "password"
    User.create!(name: name,
        email: email,
        employee_number: n+4,
        password: password,
        password_confirmation: password)
end