div.container
  a class="navbar-brand" href="/" conduit
  ul.nav.navbar-nav.pull-xs-right
    - active = context.request.path == "/" ? "active" : ""
    li class="nav-item #{active}"
      a class="nav-link" href="/" Home
    - if (current_user = context.current_user)
        - active = context.request.path == "/articles/new" ? "active" : ""
        li class="nav-item #{active}"
          a class="nav-link" href="/articles/new"
            i.ion-compose
            | New Article
        - active = context.request.path == "/settings" ? "active" : ""
        li class="nav-item #{active}"
          a class="nav-link" href="/settings"
            i.ion-gear-a
            | Settings
        - active = context.request.path == "/profile" ? "active" : ""
        li class="nav-item #{active}"
          a class="nav-link" href="/profile"
            == current_user.username
    - else
      - active = context.request.path == "/signin" ? "active" : ""
      li class="nav-item #{active}"
        a class="nav-link" href="/signin"
          | Sign In
      - active = context.request.path == "/signup" ? "active" : ""
      li class="nav-item #{active}"
        a class="nav-link" href="/signup"
          | Sign Up
