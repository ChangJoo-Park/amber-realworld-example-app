h1 Show Article
p = article.title
p = article.body
p = article.user.id
p = article.tag.id
p
  == link_to("back", "/articles", class: "btn btn-success btn-xs")
  == link_to("edit", "/articles/#{article.id}/edit", class: "btn btn-success btn-xs")
  == link_to("delete", "/articles/#{article.id}?_method=delete&_csrf=#{csrf_token}", class: "btn btn-danger btn-xs", onclick: "return confirm('Are you sure?');")
