class CreateRetweets < ActiveRecord::Migration[5.2]
  def change
    create_table :retweets do |t|
      t.integer :tweet_id
      t.integer :retweet_id
      
      t.timestamp
    end
  end
end
