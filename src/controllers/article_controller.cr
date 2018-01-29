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

  def favorite
    # FIXME: Need refactor this codes to models
    if (article = Article.find params["id"]) && (user = current_user)
      q = %Q{ WHERE #{"user_id='#{user.id}'"} AND #{"article_id='#{article.id}'"}}
      if (findExistsFavorites = Favorite.all q)
        if findExistsFavorites.size > 0
          findExistsFavorites.each do |f|
            f.destroy
          end
          redirect_back status: 302
        else
          favorite = Favorite.new
          favorite.user = user
          favorite.article = article
          if (favorite.save)
            puts "Succeed"
            redirect_back status: 302
          end
        end
      end
    else
      puts "article not exists"
    end
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
