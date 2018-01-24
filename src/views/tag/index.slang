div.row
  div.col-sm-11
    h2 Tags
  div.col-sm-1
    a.btn.btn-success.btn-xs href="/tags/new" New
div.table-responsive
  table.table.table-striped
    thead
      tr
        th Name
        th Actions
    tbody
    - tags.each do |tag|
      tr
        td = tag.name
        td
          span
            == link_to("read", "/tags/#{tag.id}", class: "btn btn-success btn-xs")
            == link_to("edit", "/tags/#{tag.id}/edit", class: "btn btn-success btn-xs")
            == link_to("delete", "/tags/#{ tag.id }?_method=delete&_csrf=#{csrf_token}", class: "btn btn-danger btn-xs", onclick: "return confirm('Are you sure?');")
