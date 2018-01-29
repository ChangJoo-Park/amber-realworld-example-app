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
            == text_field name: "profile_image", value: "#{user.profile_image}", placeholder: "URL of profile picture", class: "form-control"
          .form-group
            == text_field name: "username", value: "#{user.username}", placeholder: "User Name", class: "form-control form-control-lg"
          .form-group
            == text_area name: "bio", content: "#{user.bio}", placeholder: "Short bio about you", rows: "8", class: " form-control form-control-lg"
          .form-group
            == text_field name: "email", value: "#{user.email}", placeholder: "Email", class: "form-control form-control-lg"
          .form-group
            input.form-control.form-control-lg type="password" name="password" placeholder="New Password" value="#{user.password}"
          .form-group
            == submit("Update Settings", class: "btn btn-lg btn-primary pull-xs-right")

        div style="clear: both"
        hr style="margin-top: 5px;"
        == link_to("Or click here to logout.", "/signout", class: "btn btn-outline-danger")
