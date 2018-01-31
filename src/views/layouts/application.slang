doctype html
html
  head
    meta charset="utf-8"
    title Conduit
    meta http-equiv="X-UA-Compatible" content="IE=edge"
    meta name="viewport" content="width=device-width, initial-scale=1"
    link href="//code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css" rel="stylesheet" type="text/css"
    link href="//fonts.googleapis.com/css?family=Titillium+Web:700|Source+Serif+Pro:400,700|Merriweather+Sans:400,700|Source+Sans+Pro:400,300,600,700,300italic,400italic,600italic,700italic" rel="stylesheet" type="text/css"
    /  Import the custom Bootstrap 4 theme from our hosted CDN
    link rel="stylesheet" href="//demo.productionready.io/main.css"
    link rel="stylesheet" href="/dist/main.bundle.css"

  body
    nav.navbar.navbar-light
      == render(partial: "layouts/_nav.slang")
    - flash.each do |key, value|
      div class="alert alert-#{ key }"
        p = flash[key]
    == content
    footer
      == render(partial: "layouts/_footer.slang")
    script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"
    script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"
    script src="/dist/main.bundle.js"
