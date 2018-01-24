div.row
  div
    div
      == link_to("전체보기", "/")
    - if selectedTag
      div
        == link_to("#{selectedTag.name}", "/?tag=#{selectedTag.id}")
  div.col-sm-8
    div
    - articles.each do |article|
      div
        == article.title
      div
        == article.body
      div
        == article.created_at
        | ,
        == article.updated_at
      div
        == article.user.username
        == article.user.email
      div
        == article.tag.name
      div
        span
          == link_to("read", "/articles/#{article.id}", class: "btn btn-success btn-xs")
          == link_to("edit", "/articles/#{article.id}/edit", class: "btn btn-success btn-xs")
          == link_to("delete", "/articles/#{ article.id }?_method=delete&_csrf=#{csrf_token}", class: "btn btn-danger btn-xs", onclick: "return confirm('Are you sure?');")
  div.col-sm-4
    ul
    - tags.each do |tag|
      li
        == link_to("#{tag.name}", "/?tag=#{tag.id}")
