.settings-page
  .container.page
    .row
      .col-md-6.offset-md-3.col-xs-12
        h1.text-xs-center Your Settings
        - if user.errors
          ul.errors
          - user.errors.each do |error|
            li = error.to_s

        == form(action: "/profile", method: :patch) do
          == csrf_tag
          .form-group
            input.form-control type="text" name="username" placeholder="URL of profile picture"
          .form-group
            input.form-control.form-control-lg type="text" name="username" placeholder="User Name" value="#{user.username}"
          .form-group
            textarea.form-control.form-control-lg name="Short bio about you" placeholder="Bio" value="#{user.bio}" rows="8"
          .form-group
            input.form-control.form-control-lg type="email" name="email" placeholder="Email" value="#{user.email}"
          .form-group
            input.form-control.form-control-lg type="password" name="password" placeholder="New Password" value="#{user.password}"
          .form-group
            == submit("Update Settings", class: "btn btn-lg btn-primary pull-xs-right")

        hr style="clear: both; margin-top: 5px;"
        == link_to("Or click here to logout.", "/profile", class: "btn btn-outline-danger")

