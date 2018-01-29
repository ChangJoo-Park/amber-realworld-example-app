div.article-page
  .banner
    .container
      h1 = article.title

      div.article-meta
        a href="#"
          img src="#{article.user.profile_image}"
        div.info
          a.author href="#" = article.user.username
          span.date == time_to_string(article.created_at.not_nil!)
        button.btn.btn-sm.btn-outline-secondary
          i.ion-plus-round
          |  Follow
          = article.user.username
          span.counter (10)
        - if signed_in?
          - active = Article.is_favorited?(article, current_user) ? "btn-primary" : "btn-outline-primary"
          == form(action: "/articles/#{article.id}/favorite", method: :put, style: "display: inline-block") do
            == csrf_tag
            button.btn.btn-sm.btn-outline-primary class="#{active}"
              i.ion-heart
              span.counter Favorite Post (#{Article.favorite_count(article)})
        - else
          == link_to "/signin", class: "btn btn-outline-primary btn-sm pull-xs-right" do
            i.ion-heart
            == Article.favorite_count(article)


  .container.page
    .row.article-content
      .col-md-12 = article.body

    hr

    .article-actions
      .article-meta
        a href="#"
        img src="#{article.user.profile_image}"
        .info
          a.author href="" = article.user.username
          span.date == time_to_string(article.created_at.not_nil!)

        button.btn.btn-sm.btn-outline-secondary
          i.ion-plus-round
          |  Follow
          = article.user.username
          span.counter (10)
        - if signed_in?
          - active = Article.is_favorited?(article, current_user) ? "btn-primary" : "btn-outline-primary"
          == form(action: "/articles/#{article.id}/favorite", method: :put, style: "display: inline-block") do
            == csrf_tag
            button.btn.btn-sm.btn-outline-primary class="#{active}"
              i.ion-heart
              span.counter Favorite Post (#{Article.favorite_count(article)})
        - else
          == link_to "/signin", class: "btn btn-outline-primary btn-sm pull-xs-right" do
            i.ion-heart
            == Article.favorite_count(article)

    - unless signed_in?
      .row
        .col-xs-12.col-md-8.offset-md-2
          p
          a href="/signin" Sign in
          | or
          a href="/signup" sign up
          | to add comments on this article.
