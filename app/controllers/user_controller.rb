require "byebug"

class UserController  < Sinatra::Base


   configure do
   set :views, "app/views"
   set :public_dir, "public"
   end
   register Sinatra::ActiveRecordExtension

   get '/users/tweets' do
    @user = User.find(session[:user_id])
    @tweets = @user.tweets
    erb :'users/tweets' 

 end

 get '/users/followers' do
    @user = User.find(session[:user_id])
    followers_id = @user.followers.pluck(:user_id)
    @followers = User.all.where('id  IN (?)',followers_id)
  
    erb :'users/followers' 

 end

 get '/users/followings' do
    @user = User.find(session[:user_id])
    followings_id = @user.followings.pluck(:follower_id)
    @followings = User.all.where('id  IN (?)',followings_id)
    
    erb :'users/followings' 

 end
   

end