class Post < ActiveRecord::Base
  extend SharedMethods

  belongs_to :user

  # consts
  ACCEPTABLE_POST_TYPES = ['wall_post', 'published_story', 'created_note', 'added_photos']
  POST_REQUEST_LIMIT = 10

  def category
    self.user.category
  end

  def self.posts_for_api(params)
    if params[:category].present?
      category = Category.where(slug: params[:category])
    else
      category = nil
    end

    if category && params[:limit].present?
      posts = Post.where(category: category).limit(params[:limit])
    elsif category
      posts = Post.where(category: category)
    elsif params[:limit].present?
      posts = Post.limit(params[:limit])
    else
      posts = Post.limit(100)
    end

    posts.map do |post_obj|
      post = {}
      post[:fb_id] = post_obj.fb_id
      post[:created_time] = post_obj.created_time
      post[:message] = post_obj.message
      post[:category] = post_obj.category.name
      post[:picture] = post_obj.picture
      post
    end
  end

  def self.get_posts(user)
    graph = get_graph
    graph.get_connection(user.fb_id, 'posts', limit: POST_REQUEST_LIMIT)
  end

  def self.post_from_fb_object(fb_post)
    # makes post instance from fb post obj, updating if exists

    if ACCEPTABLE_POST_TYPES.include?(fb_post['status_type'])
      post = Post.where(fb_id: fb_post['id']).first_or_initialize
      post.created_time = fb_post['created_time']
      post.updated_time = fb_post['updaed_time']
      post.status_type = fb_post['status_type']
      post.message = fb_post['message']
      post.picture = fb_post['picture']
      return post
    end
  end
end
