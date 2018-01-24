require "granite_orm/adapter/pg"

class Article < Granite::ORM::Base
  adapter pg
  table_name articles

  belongs_to :user
  belongs_to :tag

  # id : Int64 primary key is created for you
  field title : String
  field body : String
  timestamps

  def self.search(tag)
    q = %Q{ WHERE #{"tag_id='#{tag}'" if tag} ORDER BY created_at DESC }
    if tag
      self.all q
    else
      self.all("ORDER BY created_at DESC")
    end
  end
end
