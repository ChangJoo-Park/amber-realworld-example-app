div.home-page
  == render partial: "_banner.slang"
  
  div.container
    div.row
      div.col-md-9
        div.feed-toggle
          ul.nav.nav-pills.outline-active
            - if signed_in?
              - active = is_mine ? "active" : ""
              li.nav-item
                a.nav-link href="/?mine=true" class="#{active}" Your Feed
            - active = is_global ? "active" : ""
            li.nav-item
              == link_to("Global Feed", "/", class: "nav-link #{active}")
            - if selectedTag
              - active = has_tag ? "active" : ""
              li.nav-item
                == link_to("# #{selectedTag.name}", "/?tag=#{selectedTag.id}", class: "nav-link #{active}")

        - articles.each do |article|
          == render partial: "_article.slang"

      div.col-md-3
        div.sidebar
          p Popular Tags

          div.tag-list
            - tags.each do |tag|
              == link_to("#{tag.name}", "/?tag=#{tag.id}", class: "tag-pill tag-default")
