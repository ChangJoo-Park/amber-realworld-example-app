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
