a href="#"
  img src="#{article.user.profile_image}"
  .info
    a.author href="" = article.user.username
    span.date == time_to_string(article.created_at.not_nil!)
