class ApplicationController < ActionController::Base
  protect_from_forgery

  def get_test
    @graph = get_graph
    user_ids = User.pluck(:fb_id)
    
    user_ids.each do |user_id|
      post_ids = @graph.get_connection(user_id, 'feed').map { |post| post.id }

      post_ids.each do |post_id|
        post = @graph.get_object(post_id)

        Post.create(fb_id: post['id'], type: post['type'], message: post['message'])
      end
    end
  end
end
