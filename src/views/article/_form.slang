.editor-page
  .container.page
    - if article.errors
      ul.errors
      - article.errors.each do |error|
        li = error.to_s
    .row
      .col-md-10.offset-md-1.col-xs-12
        == form(action: "/articles/#{article.id.to_s}", method: article.id ? :patch : :post) do
          == csrf_tag
          div.form-group
          == text_field(name: "title", value: article.title, placeholder: "Article Title", class: "form-control form-control-lg")
          div.form-group
          == text_field(name: "summary", value: article.summary, placeholder: "What's this article about?", class: "form-control")
          div.form-group
          == text_area(name: "body", content: article.body, placeholder: "Write your article (in markdown)", class: "form-control", rows: "8")
          div.form-group
          == text_field(name: "tags", placeholder: "Enter tags", class: "form-control")
          div.form-group
          == submit("Publish Article", class: "btn btn-lg pull-xs-right btn-primary")
