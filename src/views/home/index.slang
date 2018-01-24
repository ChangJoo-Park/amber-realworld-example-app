div.home-page
  div.banner
    div.container
      h1.logo-font conduit
      p A place to share your knowledge.
div.container
  div.row
    div.col-md-9
      div.feed-toggle
        ul.nav.nav-pills.outline-active
          li.nav-item
            == link_to("전체보기", "/", class: "nav-link")
          - if selectedTag
            li.nav-item
              == link_to("#{selectedTag.name}", "/?tag=#{selectedTag.id}", class: "nav-link")

      - articles.each do |article|
        div.article-preview
          div.article-meta
            a href=""
              img src="http://i.imgur.com/Qr71crq.jpg"
            div.info
              a href="" class="author"
                == article.user.username
              span.date
                == article.user.created_at
            button.btn.btn-outline-primary.btn-sm.pull-xs-right
              i.ion-heart
              |  29
          a.preview-link href=""
            h1
              == article.title
            p
              == article.body
            span Read more...
            ul.tag-list
              li.tag-default.tag-pill.tag-outline
                == article.tag.name
          / div
          /   == link_to("read", "/articles/#{article.id}", class: "btn btn-success btn-xs")
          /   == link_to("edit", "/articles/#{article.id}/edit", class: "btn btn-success btn-xs")
          /   == link_to("delete", "/articles/#{ article.id }?_method=delete&_csrf=#{csrf_token}", class: "btn btn-danger btn-xs", onclick: "return confirm('Are you sure?');")
    div.col-md-3
      div.sidebar
        p Popular Tags

      div.tag-list
      - tags.each do |tag|
        == link_to("#{tag.name}", "/?tag=#{tag.id}", class: "tag-pill tag-default")
