require "byebug"

class HomeController  < Sinatra::Base


   configure do
   set :views, "app/views"
   set :public_dir, "public"
   end
   register Sinatra::ActiveRecordExtension


 get '/users/home' do
    if session[:user_id] == nil
        redirect '/sessions/login'
      else
       
        @user = User.find(session[:user_id])
        @tweets = @user.tweets.last(4)
        followings_id = @user.followings.pluck(:follower_id)
        @followings = User.all.where('id  IN (?)',followings_id)
    #===================================================================    
        except_users = @user.followings.pluck(:follower_id).push(@user.id)
        @who_to_follow = User.all.where('id NOT IN (?)',except_users)
        @who_to_follow = @who_to_follow.sample(3)
        
        erb :'/users/user_home', layout: :'/layouts/users_home_layout'

    end

end



#Tagreed 
get '/:nickname' do
@other_user = User.find_by(nickname:params["nickname"])
@user=@other_user
#byebug
   unless @other_user.nil?
   @other_tweets =  @other_user.tweets.last(4)
   except_users = @user.followings.pluck(:follower_id).push(@user.id)
   @who_to_follow = User.all.where('id NOT IN (?)',except_users)
   @who_to_follow = @who_to_follow.sample(3)
   erb :'/users/profile_home', layout: :'/layouts/users_home_layout'
  else
    raise Sinatra::NotFound
  end
 end


    
post '/tweet' do
       @tweet=Tweet.create(text:params["tweet"] ,liked_count:0,reply_count:0,retweet_count: 0,user_id: session[:user_id] )
       redirect '/users/home'
end

 get '/follower/:id' do
    @user = User.find(session[:user_id])
   
   Follower.create(user_id:@user.id ,follower_id: params["id"])
 
  redirect   'users/home' 

 end

 get '/following/:id' do
  @user = User.find(session[:user_id])
  following= @user.followings.find_by(follower_id: params[:id])
  
  following.destroy
  redirect "/users/home"
end


 

end