$LOAD_PATH.push *Dir[File.join(File.dirname(__FILE__), '..', '..', 'vendor', '*', 'lib')]

require 'dm-core'
require 'digest/md5'

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
    property :email,                String, :unique => true, :length => 255
    property :name,                 String, :unique => true, :length => 100
    
    has n, :posts, :class_name => "Pants::Post", :order => [:created_at.desc]
    has n, :comments, :class_name => "Pants::Comment", :order => [:created_at.desc]
    
    def gravatar
      md5 = Digest::MD5.new.update(email)
      url = "http://www.gravatar.com/avatar/#{md5}"
      "<img src=\"#{url}\">"
    end
  end
  
  class Post
    include DataMapper::Resource
    property :id,                   Serial
    property :title,                String, :length => 255
    property :slug,                 String, :key => true, :index => true, :length => 255
    property :published,            Boolean, :default => false
    property :created_at,           DateTime, :default => Proc.new { Time.now }
    property :updated_at,           DateTime, :default => Proc.new { Time.now }
    property :published_at,         DateTime, :index => true
    property :summary,              Text
    property :body,                 Text
    
    belongs_to :user, :class_name => "Pants::User"
    has n, :comments, :class_name => "Pants::Comment", :order => [:created_at]
    
    def gravatar
      user.gravatar
    end
    
    def author
      user.name
    end
    
    def url
      published_at.strftime("/post/%Y/%m/%d/") + slug
    end
    
    def comment_url
      published_at.strftime("/comments/%Y/%m/%d/") + slug
    end
  end
  
  class Comment
    include DataMapper::Resource
    property :id,                 Serial
    property :author_name,        String, :default => "Anonymous", :length => 100
    property :author_email,       String, :length => 255
    property :author_website,     String, :length => 255
    property :ip_address,         String
    property :http_user_agent,    String, :length => 255
    property :created_at,         DateTime, :default => Proc.new { Time.now }
    property :updated_at,         DateTime, :default => Proc.new { Time.now }
    property :body,               Text

    belongs_to :post,             :class_name => "Pants::Post"
    belongs_to :user,             :class_name => "Pants::User"
    
    def author_link
      if author_website.to_s.size > 0
        "<a href=\"http://#{author_website}\">#{author_name}</a>"
      else
        author_name.to_s
      end
    end
    
    def gravatar
      user ? user.gravatar : "<img src=\"http://www.gravatar.com/avatar/#{Digest::MD5.new.update(author_email)}\">"
    end
  end
  
  class Setting
    include DataMapper::Resource
    property :id, Serial
    property :name, String, :unique => true
    property :value, String, :length => 255
    
    def self.[](k)
      Setting.first(:name => k.to_s).value
    end

    def self.[]=(k,v)
      k = k.to_s
      s = Setting.first(:name => k) || Setting.create(:name => k)
      s.update_attributes(:value => v)
    end
  end
end
