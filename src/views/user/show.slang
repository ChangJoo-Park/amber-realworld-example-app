.profile-page
  .user-info
    .container
      .row
        .col-xs-12.col-md-10.offset-md-1
          img.user-img src="#{user.profile_image}"
          h4 == user.username
          p == user.bio
          button.btn.btn-sm.btn-outline-secondary.action-btn
            i.ion-plus-round
            | Follow
            == user.username

  .container
    .row
      .col-xs-12.col-md-10.offset-md-1
        .articles-toggle
          ul.nav.nav-pills.outline-active
            li.nav-item
              a.nav-link.active href="#" My Articles
            li.nav-item
              a.nav-link href="#" Favorite Articles

        - articles.each do |article|
          .article-preview
            .article-meta
              a
                img src="#{article.user.profile_image}"
              .info
                a href="" class="author"
                  == article.user.username
                span.date
                  == article.created_at
              button.btn.btn-outline-primary.btn-sm.pull-xs-right
                i.ion-heart
                |  29
            == link_to "/articles/#{article.id}", class: "preview-link" do
              h1 == article.title
              p == article.summary
              span Read more..
