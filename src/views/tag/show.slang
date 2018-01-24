h1 Show Tag
p = tag.name
p
  == link_to("back", "/tags", class: "btn btn-success btn-xs")
  == link_to("edit", "/tags/#{tag.id}/edit", class: "btn btn-success btn-xs")
  == link_to("delete", "/tags/#{tag.id}?_method=delete&_csrf=#{csrf_token}", class: "btn btn-danger btn-xs", onclick: "return confirm('Are you sure?');")
