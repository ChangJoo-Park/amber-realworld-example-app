.profile-page
  .user-info
    .container
      .row
        .col-xs-12.col-md-10.offset-md-1
          img.user-img src="#{user.profile_image}"
          h4 == user.username
          p == user.bio

          button.btn.btn-sm.btn-outline-secondary.action-btn
            i.ion-gear-a
            | Edit Profile Setting

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
          == render partial: "_article.slang"
