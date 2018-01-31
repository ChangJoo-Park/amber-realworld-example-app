.article-preview
  .article-meta
    a
      img src="#{article.user.profile_image}"
    .info
      a href="" class="author"
        == article.user.username
      span.date
        == time_to_string(article.created_at.not_nil!)
    - if signed_in?
      - active = Article.is_favorited?(article, current_user) ? "btn-primary" : "btn-outline-primary"
      == form(action: "/articles/#{article.id}/favorite", method: :put) do
        == csrf_tag
        button.btn.btn-sm.pull-xs-right.btn-favorite class="#{active}"
          i.ion-heart
          == Article.favorite_count article
    - else
      == link_to "/signin", class: "btn btn-outline-primary btn-sm pull-xs-right" do
        i.ion-heart
        == Article.favorite_count(article)
  == link_to "/articles/#{article.id}", class: "preview-link" do
    h1 == article.title
    p == article.summary
    span Read more..
