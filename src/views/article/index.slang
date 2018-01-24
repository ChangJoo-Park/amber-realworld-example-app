div.row
  div.col-sm-11
    h2 Articles
  div.col-sm-1
    a.btn.btn-success.btn-xs href="/articles/new" New
div.table-responsive
  table.table.table-striped
    thead
      tr
        th Title
        th Body
        th User
        th Tag
        th Actions
    tbody
    - articles.each do |article|
      tr
        td = article.title
        td = article.body
        td = article.user.id
        td = article.tag.id
        td
          span
            == link_to("read", "/articles/#{article.id}", class: "btn btn-success btn-xs")
            == link_to("edit", "/articles/#{article.id}/edit", class: "btn btn-success btn-xs")
            == link_to("delete", "/articles/#{ article.id }?_method=delete&_csrf=#{csrf_token}", class: "btn btn-danger btn-xs", onclick: "return confirm('Are you sure?');")
