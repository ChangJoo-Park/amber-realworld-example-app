div.container
  a class="navbar-brand" href="/" conduit
  ul.nav.navbar-nav.pull-xs-right
    - active = context.request.path == "/" ? "active" : ""
    li class="nav-item #{active}"
      a class="nav-link" href="/" Home
    - active = context.request.path == "/articles" ? "active" : ""
    li class="nav-item #{active}"
      a class="nav-link" href="/articles" Articles
    - active = context.request.path == "/tags" ? "active" : ""
    li class="nav-item #{active}"
      a class="nav-link" href="/tags" Tags
    - if (current_user = context.current_user)
      li class="nav-item #{active}"
        a.nav-link href="/signout"
          | Sign Out
        - active = context.request.path == "/profile" ? "active" : ""
        li class="nav-item #{active}"
          a class="nav-link" href="/profile"
            == current_user.email
    - else
      - active = context.request.path == "/signin" ? "active" : ""
      li class="nav-item #{active}"
        a class="nav-link" href="/signin"
          | Sign In
      - active = context.request.path == "/signup" ? "active" : ""
      li class="nav-item #{active}"
        a class="nav-link" href="/signup"
          | Sign Up
