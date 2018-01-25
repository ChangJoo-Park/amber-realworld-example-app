.auth-page
  .container.page
    .row
      .col-md-6.offset-md-3.col-xs-12
        h1.text-xs-center Sign Up
        p.text-xs-center
          == link_to("Have an account?", "/signin")

        - if user.errors
          ul.error-messages
          - user.errors.each do |error|
            li = error.to_s

        form action="/registration" method="post"
          == csrf_tag
          fieldset.form-group
            input.form-control type="email" name="email" placeholder="Email"
          fieldset.form-group
            input.form-control type="password" name="password" placeholder="Password"
          button.btn.btn-lg.btn-primary.pull-xs-right type="submit"
            | Sign Up



