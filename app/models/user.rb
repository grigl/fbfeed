class User < ActiveRecord::Base
  include SharedMethods
  
  belongs_to :category
  has_many :posts

  # validations
  validates :fb_id, uniqueness: true
  validate :should_be_real_fb_user

  # callbacks
  before_create :get_real_data_from_fb
  after_create :load_posts

  def self.user_from_fb_object(fb_user)
    # makes user instance from fb user obj, updating if exists

    user = User.where(fb_id: fb_user['id']).first_or_initialize
    user.name = fb_user['name']
    return user
  end

  def get_posts
    Post.get_posts(self)
  end

  def get_posts_ids
    posts = get_posts
    posts.map { |post| post['id'] }
  end

  def load_posts
    # loads last posts from fb or updates if exists

    graph = get_graph
    post_ids = self.get_posts_ids

    post_ids.each do |post_id|
      fb_post = graph.get_object(post_id)
      post = Post.post_from_fb_object(fb_post)

      if post
        post.user = self
        post.save!
      end
    end
  end

  def is_real_fb_user?
    graph = get_graph

    begin
      fb_user = graph.get_object(self.fb_id)
    rescue
      return false
    else
      return true
    end
  end

  def get_real_data_from_fb
    # get name from fb and swap username to fb id if username was given in form

    graph = get_graph
    fb_user = graph.get_object(self.fb_id)
    self.fb_id = fb_user['id']
    self.name = fb_user['name']
  end

  def should_be_real_fb_user
    unless self.is_real_fb_user?
      errors.add(:fb_id, 'should be id or username of a real fb user') 
    end
  end
end
