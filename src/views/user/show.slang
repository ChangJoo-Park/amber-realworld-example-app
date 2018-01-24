h1 Profile
div
  == user.username
div
  == user.admin
div
  == user.email
div
  == link_to("edit", "/profile/edit", class: "btn btn-success btn-xs")
