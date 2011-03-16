require 'mongoid'
require 'ruport'
Mongoid.configure do |config|
  config.master = Mongo::Connection.new('127.0.0.1', 27017).db("lolita-report-test")
end

class Post
  include Mongoid::Document
  references_many :comments
  field :title
  field :content
end

class Comment
  include Mongoid::Document
  referenced_in :post
  field :content
end

class ActiveSupport::TestCase
  setup do
    Post.delete_all
  end
end