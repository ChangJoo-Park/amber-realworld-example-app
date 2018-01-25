class HomeController < ApplicationController
  PER_PAGE = 10

  def index
    query, current_page, tag = query_param, page_param, tag_param
    articles = Article.search(tag: tag)
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
end
