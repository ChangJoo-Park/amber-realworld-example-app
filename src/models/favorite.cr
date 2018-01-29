require "granite_orm/adapter/pg"

class Favorite < Granite::ORM::Base
  adapter pg
  table_name favorites

  belongs_to :user
  belongs_to :article

  # id : Int64 primary key is created for you
  timestamps
end
