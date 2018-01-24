require "granite_orm/adapter/pg"

class Tag < Granite::ORM::Base
  adapter pg
  table_name tags

  has_many :articles

  # id : Int64 primary key is created for you
  field name : String
  timestamps
end
