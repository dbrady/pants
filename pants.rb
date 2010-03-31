require 'rubygems'
require 'sinatra'
require 'dm-core'

$: << File.join(File.dirname(__FILE__), 'lib')
require 'pants/models'
#require 'pants/calendar_helper'

include Pants

$0 = __FILE__

error do
  e = request.env['sinatra.error']
  puts "#{e.class}: #{e.message}\n#{e.backtrace.join("\n  ")}"
end

configure do
  require File.dirname(__FILE__) + '/config/pants.rb'
end

get '/' do
  @posts = Pants::Post.all()
  erb :index
end

get '/post/:year/:month/:mday/:slug' do
  # this is pretty gross--need to find right way to search for a DateTime when you have Y/m/d
  # or at least tuck these entrails into a finder
  date1 = Date.parse("%04d-%02d-%02d" % [params[:year].to_i, params[:month].to_i, params[:mday].to_i])
  date2 = date1 + 1
  @post = Pants::Post.first( :slug => params[:slug], :published_at.gt => date1.strftime("%F"), :published_at.lt => date2.strftime("%F") )
  erb :post
end 

get '/comments/:year/:month/:mday/:slug' do
  date1 = Date.parse("%04d-%02d-%02d" % [params[:year].to_i, params[:month].to_i, params[:mday].to_i])
  date2 = date1 + 1
  @post = Pants::Post.first( :slug => params[:slug], :published_at.gt => date1.strftime("%F"), :published_at.lt => date2.strftime("%F") )
  erb :comment
end 

post '/comments/:year/:month/:mday/:slug' do
  date1 = Date.parse("%04d-%02d-%02d" % [params[:year].to_i, params[:month].to_i, params[:mday].to_i])
  date2 = date1 + 1
  @post = Pants::Post.first( :slug => params[:slug], :published_at.gt => date1.strftime("%F"), :published_at.lt => date2.strftime("%F") )

  params[:created_at] = Time.now
  params[:updated_at] = Time.now
  
  if @post
    Pants::Comment.create(
                          :post => @post,
                          :author_name => params[:author_name],
                          :author_email => params[:author_email],
                          :author_website => params[:author_website],
                          :body => params[:body],
                          :http_user_agent => request.env['HTTP_USER_AGENT'],
                          :ip_address => request.env['REMOTE_ADDR'],
                          :user => nil)
    redirect @post.url
  end
end 
