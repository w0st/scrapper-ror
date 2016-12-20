# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
User.create(email: 'normal@domain.com', password: 'password', password_confirmation: 'password')
User.create(email: 'premium@domain.com', status: :premium, password: 'password', password_confirmation: 'password')
User.create(email: 'premium_plus@domain.com', status: :premium_plus, password: 'password', password_confirmation: 'password')
Product.create(slug: 'desk-calendars', title: 'Desk Calendars, Offset Printing', price_net: 120.12, price_gross: 144.14)
