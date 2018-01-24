h1 Edit Profile

- if user.errors
  ul.errors
  - user.errors.each do |error|
    li = error.to_s

== form(action: "/profile", method: :patch) do
  == csrf_tag
  .form-group
    input.form-control type="text" name="username" placeholder="User Name" value="#{user.username}"
  / .form-group
  /   label
  /     input type="checkbox" name="admin" value="#{user.admin}"
  /     | Admin
  .form-group
    input.form-control type="email" name="email" placeholder="Email" value="#{user.email}"
  .form-group
    textarea.form-control name="bio" placeholder="Bio" value="#{user.bio}"
  == submit("Update", class: "btn btn-primary btn-xs")
  == link_to("profile", "/profile", class: "btn btn-default btn-xs")
