class ArticleController < ApplicationController
  def index
    articles = Article.all
    render("index.slang")
  end

  def show
    if article = Article.find params["id"]
      render("show.slang")
    else
      flash["warning"] = "Article with ID #{params["id"]} Not Found"
      redirect_to "/articles"
    end
  end

  def new
    article = Article.new
    render("new.slang")
  end

  def create
    article = Article.new(article_params.validate!)

    if article.valid? && article.save
      flash["success"] = "Created Article successfully."
      redirect_to "/articles"
    else
      flash["danger"] = "Could not create Article!"
      render("new.slang")
    end
  end

  def edit
    if article = Article.find params["id"]
      render("edit.slang")
    else
      flash["warning"] = "Article with ID #{params["id"]} Not Found"
      redirect_to "/articles"
    end
  end

  def update
    if article = Article.find(params["id"])
      article.set_attributes(article_params.validate!)
      if article.valid? && article.save
        flash["success"] = "Updated Article successfully."
        redirect_to "/articles"
      else
        flash["danger"] = "Could not update Article!"
        render("edit.slang")
      end
    else
      flash["warning"] = "Article with ID #{params["id"]} Not Found"
      redirect_to "/articles"
    end
  end

  def destroy
    if article = Article.find params["id"]
      article.destroy
    else
      flash["warning"] = "Article with ID #{params["id"]} Not Found"
    end
    redirect_to "/articles"
  end

  def article_params
    params.validation do
      required(:title) { |f| !f.nil? }
      required(:body) { |f| !f.nil? }
      required(:summary) { |f| !f.nil? }
      required(:user_id) { |f| !f.nil? }
      required(:tag_id) { |f| !f.nil? }
    end
  end
end
