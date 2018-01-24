- if article.errors
  ul.errors
  - article.errors.each do |error|
    li = error.to_s

== form(action: "/articles/#{article.id.to_s}", method: article.id ? :patch : :post) do
  == csrf_tag
  div.form-group
  == text_field(name: "title", value: article.title, placeholder: "Title", class: "form-control")
  div.form-group
  == text_area(name: "body", content: article.body, placeholder: "Body", class: "form-control", size: "30x10")
  div.form-group
    == label(:user)
    == select_field(name: "user_id", collection: User.all.map{|user| [user.id, user.id]}, selected: article.user_id, class: "form-control")
  div.form-group
    == label(:tag)
    == select_field(name: "tag_id", collection: Tag.all.map{|tag| [tag.id, tag.id]}, selected: article.tag_id, class: "form-control")
  == submit("Submit", class: "btn btn-primary btn-xs")
  == link_to("back", "/articles", class: "btn btn-default btn-xs")
