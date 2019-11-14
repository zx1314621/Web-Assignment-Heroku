require 'dm-core'
require 'dm-migrations'
require 'dm-serializer'
require 'dm-types'
require 'date_helper'

class Student
  include DataMapper::Resource
  property :id, Serial
  property :firstname, String
  property :lastname, String
  property :birthday, String
  property :address, String
  property :password, String
end

class Comment
  include DataMapper::Resource
  property :id, Serial
  property :title, String
  property :content, Text
  property :created_at, EpochTime
end

DataMapper.finalize
DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/model.db")

DataMapper.auto_upgrade!
