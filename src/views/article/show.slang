div.article-page
  .banner
    .container
      h1 = article.title

      div.article-meta
        a href="#"
          img src="#{article.user.profile_image}"
        div.info
          a.author href="#" = article.user.username
          span.date = article.created_at
        button.btn.btn-sm.btn-outline-secondary
          i.ion-plus-round
          |  Follow
          = article.user.username
          span.counter (10)
        button.btn.btn-sm.btn-outline-primary
          i.ion-heart
          |  Favorite Post
          span.counter (29)

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
          span.date = article.created_at

        button.btn.btn-sm.btn-outline-secondary
          i.ion-plus-round
          |  Follow
          = article.user.username
          span.counter (10)
        button.btn.btn-sm.btn-outline-primary
          i.ion-heart
          |  Favorite Post
          span.counter (29)

    - unless signed_in?
      .row
        .col-xs-12.col-md-8.offset-md-2
          p
          a href="/signin" Sign in
          | or
          a href="/signup" sign up
          | to add comments on this article.
