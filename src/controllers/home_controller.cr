class HomeController < ApplicationController
  PER_PAGE = 10

  def index
    query, current_page, tag, mine = query_param, page_param, tag_param, mine_param
    has_tag = false
    is_mine = false
    is_global = !tag && !mine
    if tag
      has_tag = true
      articles = Article.search(tag: tag)
    elsif mine
      is_mine = true
      if (user = current_user)
        articles = Article.search(tag: tag)
      else
        articles = Article.find_by_current_user(user)
      end
    else
      articles = Article.search(tag: tag)
    end


    tags = Tag.all
    if tag
      selectedTag = Tag.find(tag)
    end
    render("index.slang")
  end

  private def query_param
    params["query"]?.try &.gsub /[^0-9A-Za-z_\-\s]/, ""
  end

  private def page_param
    [params.fetch("page", "1").to_i { 1 }, 1].max
  end

  private def tag_param
    type = params["tag"]?
  end

  private def mine_param
    mine = params["mine"]?
  end
end
