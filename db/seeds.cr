require "faker"
require "../config/application.cr"

User.clear
user = User.new
user.username = "Admin"
user.profile_image = "http://placehold.it/50x50.jpg/ffffff/000?text=Admin"
user.email = "admin@example.com"
user.password = "password"
user.admin = true
user.save

Tag.clear
[1, 2, 3, 4, 5].each do |index|
  tag = Tag.new
  tag.name = Faker::Lorem.word
  tag.save
end

Article.clear

tags = Tag.all
[1, 2, 3, 4, 5, 6, 7, 8, 9, 10].each do |index|
  article = Article.new
  article.title = Faker::Lorem.sentence
  article.summary = Faker::Lorem.sentence
  article.body = Faker::Lorem.paragraph(4)
  article.user = user
  article.tag = tags.sample
  article.save
end

Favorite.clear
