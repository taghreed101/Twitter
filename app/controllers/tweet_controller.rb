require "byebug"

class TweetController  < Sinatra::Base


   configure do
   set :views, "app/views"
   set :public_dir, "public"
   end
   register Sinatra::ActiveRecordExtension



delete '/tweets/:id' do
    Tweet.find(params[:id]).destroy
    redirect "/users/home"
  end
  
  get '/tweets/:id/edit' do  #load edit form
      @tweet = Tweet.find(params[:id])
      erb :"tweets/edit" #??
  end
  
  put '/tweets/:id' do
    tweet = Tweet.find(params[:id])
    tweet.name = params[:name]
    tweet.save
    redirect "/tweets/#{@tweet.id}"
  end


  post '/reply' do
    @user = User.find(session[:user_id])
   
    @tweet=Tweet.create(text:params["tweet_text"] ,liked_count:0,reply_count:0,retweet_count: 0,user_id: session[:user_id] )
    byebug
    Reply.create(tweet_id:params["tweet_id"] ,reply_id: @tweet.id)
  
   redirect   'users/home' 
  end
  
post '/retweet' do
    @user = User.find(session[:user_id])
   
    @tweet=Tweet.create(text:params["tweet_text"] ,liked_count:0,reply_count:0,retweet_count: 0,user_id: session[:user_id] )
    
    Retweet.create(tweet_id:params["tweet_id"]  ,retweet_id:@tweet.id )
    byebug
   redirect   'users/home' 
  end
  
  get '/like/:tweet_id' do
    @user = User.find(session[:user_id])
   like_tweet=Like.find_by(user_id:@user.id)
   
   if like_tweet.nil?
    @tweet=Tweet.find(params["tweet_id"])
    @tweet.liked_count +=1
    @tweet.save
    Like.create(user_id:@user.id,tweet_id:params["tweet_id"])
   else
   # byebug
    like_tweet.destroy
    @tweet=Tweet.find(params["tweet_id"])
    @tweet.liked_count -=1 unless @tweet.liked_count >0  
    @tweet.save
   end
  
   redirect   'users/home' 
  end


end


