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
              a.nav-link href="#" Your Feed
            li.nav-item
              == link_to("Global Feed", "/", class: "nav-link active")
            - if selectedTag
              li.nav-item
                == link_to("#{selectedTag.name}", "/?tag=#{selectedTag.id}", class: "nav-link")

        - articles.each do |article|
          div.article-preview
            div.article-meta
              a href=""
                img src="#{article.user.profile_image}"
              div.info
                a href="" class="author"
                  == article.user.username
                span.date
                  == article.created_at
              - if signed_in?
                - active = Article.is_favorited?(article, current_user) ? "btn-primary" : "btn-outline-primary"
                == form(action: "/articles/#{article.id}/favorite", method: :put) do
                  == csrf_tag
                  button.btn.btn-sm.pull-xs-right class="#{active}"
                    i.ion-heart
                    == Article.favorite_count article
              - else
                == link_to "/signin", class: "btn btn-outline-primary btn-sm pull-xs-right" do
                  i.ion-heart
                  == Article.favorite_count(article)
            == link_to "/articles/#{article.id}", class: "preview-link" do
              h1
                == article.title
              p
                == article.summary
              span Read more...
              ul.tag-list
                li.tag-default.tag-pill.tag-outline
                  == article.tag.name
      div.col-md-3
        div.sidebar
          p Popular Tags

          div.tag-list
            - tags.each do |tag|
              == link_to("#{tag.name}", "/?tag=#{tag.id}", class: "tag-pill tag-default")
