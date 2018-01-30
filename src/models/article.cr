require "granite_orm/adapter/pg"
require "markdown"
require "autolink"

class Article < Granite::ORM::Base
  adapter pg
  table_name articles

  belongs_to :user
  belongs_to :tag
  has_many :favorites
  # has_many :favorite_users, through: favorites

  # id : Int64 primary key is created for you
  field title : String
  field body : String
  field summary : String
  timestamps

  def self.search(tag)
    q = %Q{ WHERE #{"tag_id='#{tag}'" if tag} ORDER BY created_at DESC }
    if tag
      self.all q
    else
      self.all("ORDER BY created_at DESC")
    end
  end

  def self.find_by_current_user (user)
    q = %Q{ WHERE #{"user_id='#{user.id}'" if user} ORDER BY created_at DESC }
    self.all q
  end

  def self.favorite_count (article)
    q = %Q{ WHERE #{"article_id='#{article.id}'"}}
    findExistsFavorites = Favorite.all q
    findExistsFavorites.size
  end

  def self.is_favorited?(article, current_user)
    if (user = current_user)
      q = %Q{ WHERE #{"user_id='#{user.id}'"} AND #{"article_id='#{article.id}'"}}
      findExistsFavorites = Favorite.all q
      findExistsFavorites.size > 0
    else
      false
    end
  end

  def content
    Autolink.auto_link(Markdown.to_html(body.not_nil!))
  end
end
