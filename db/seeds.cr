require "../config/application.cr"

User.clear
user = User.new
user.email = "admin@example.com"
user.password = "password"
user.save

Article.clear
article = Article.new
article.title = "HELLO"
article.body = "BODY"
article.save
