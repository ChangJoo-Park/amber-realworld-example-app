.auth-page
  .container.page
    .row
      .col-md-6.offset-md-3.col-xs-12
        h1.text-xs-center Sign In
        p.text-xs-center
          == link_to("Need an account?", "/register")

        - if user.errors
          ul.error-messages
          - user.errors.each do |error|
            li = error.to_s

        form action="/session" method="post"
          == csrf_tag
          fieldset.form-group
            input.form-control.form-control-lg type="email" name="email" placeholder="Email"
          fieldset.form-group
            input.form-control.form-control-lg type="password" name="password" placeholder="Password"
          button.btn.btn-lg.btn-primary.pull-xs-right type="submit"
            | Sign In
