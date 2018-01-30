.article-page
  .banner
    .container
      h1 = article.title

      .article-meta
        == render partial: "_user_info.slang"
        == render partial: "_follow_button.slang"
        == render partial: "_favorite_button.slang"

  .container.page
    .row.article-content
      .col-md-12 == article.content

    hr

    .article-actions
      .article-meta
        == render partial: "_user_info.slang"
        == render partial: "_follow_button.slang"
        == render partial: "_favorite_button.slang"

    - unless signed_in?
      .row
        .col-xs-12.col-md-8.offset-md-2
          p
          a href="/signin" Sign in
          | or
          a href="/signup" sign up
          | to add comments on this article.
