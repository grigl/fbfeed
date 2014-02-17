require 'spec_helper'

shared_context "with oauth" do
  app_access_token = Koala::Facebook::OAuth.new(APP_ID, APP_SECRET).get_app_access_token
  oauth = Koala::Facebook::API.new(app_access_token)
  let (:oauth) { oauth }
  let (:test_fb_post_id) { '20528438720_10151992763913721' }
end

describe Post do
  include_context "with oauth"

  it "should create post instance from facebook object" do
    fb_post = oauth.get_object(test_fb_post_id)
    
    Post.post_from_fb_object(fb_post).save!
    post = Post.where(fb_id: test_fb_post_id).first
 
    expect(post.fb_id).to eq(fb_post['id'])
    expect(post.message).to eq(fb_post['message'])
    expect(post.picture).to eq(fb_post['picture'])
  end
end