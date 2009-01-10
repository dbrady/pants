$LOAD_PATH.push *Dir[File.join(File.dirname(__FILE__), '..', '..', 'vendor', '*', 'lib')]

require 'dm-core'

module Pants
  class User
    include DataMapper::Resource
    property :id,                   Integer, :serial => true
    property :login,                String, :unique => true
    property :password_hash,        String
    property :admin,                Boolean, :default => false
    property :trusted,              Boolean, :default => false
    property :created_at,           DateTime, :default => Proc.new { Time.now }
    property :updated_at,           DateTime, :default => Proc.new { Time.now }
    property :email,                String, :unique => true
    property :name,                 String, :unique => true
    
    has n, :posts, :class_name => "Pants::Post", :order => [:created_at.desc]
    has n, :comments, :class_name => "Pants::Comment", :order => [:created_at.desc]
  end
  
  class Post
    include DataMapper::Resource
    property :id,                   Serial
    property :title,                String
    property :slug,                 String, :key => true, :index => true
    property :published,            Boolean, :default => false
    property :created_at,           DateTime, :default => Proc.new { Time.now }
    property :updated_at,           DateTime, :default => Proc.new { Time.now }
    property :published_at,         DateTime, :index => true
    property :summary,              Text
    property :body,                 Text
    
    belongs_to :user, :class_name => "Pants::User"
    has n, :comments, :class_name => "Pants::Comment", :order => [:created_at.desc]
  end
  
  class Comment
    include DataMapper::Resource
    property :id,                 Serial
    property :author_name,        String, :default => "Anonymous"
    property :author_email,       String
    property :author_website,     String
    property :created_at,         DateTime, :default => Proc.new { Time.now }
    property :updated_at,         DateTime, :default => Proc.new { Time.now }
    property :body,               Text

    belongs_to :post,             :class_name => "Pants::Post"
  end
end
