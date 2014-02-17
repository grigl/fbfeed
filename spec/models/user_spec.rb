require 'spec_helper'

shared_context "with fb_user" do
  app_access_token = Koala::Facebook::OAuth.new(APP_ID, APP_SECRET).get_app_access_token
  oauth = Koala::Facebook::API.new(app_access_token)
  test_fb_user_id = '20528438720' 

  let (:oauth) { oauth }
  let (:test_fb_user_id) { test_fb_user_id }
  let (:fb_user) { oauth.get_object(test_fb_user_id) }
  let (:fake_fb_user) { 'sdfgsdfggjtrytynmfgxbqerfvascva' }
  let (:acceptable_post_types ) { Post::ACCEPTABLE_POST_TYPES }
  let (:post_request_limit) { Post::POST_REQUEST_LIMIT }
end

describe User do
  include_context "with fb_user"

  it "should load existing posts" do
    user_posts_ids = oauth.get_connections(test_fb_user_id, 'posts', limit: post_request_limit).map do |post|
      post['id'] if acceptable_post_types.include?(post['status_type'])
    end.compact

    user = User.user_from_fb_object(fb_user)
    user.save!

    user.load_posts

    user_posts_ids.each do |post_id|
      expect(Post.where(fb_id: post_id)).to exist
    end
  end

  it "should create user instance from facebook object" do    
    User.user_from_fb_object(fb_user).save!    
    user = User.where(fb_id: test_fb_user_id).first

    expect(user.fb_id).to eq(fb_user['id'])
    expect(user.name).to eq(fb_user['name'])
  end
end