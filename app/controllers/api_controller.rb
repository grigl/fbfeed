class ApiController < ApplicationController
  def tags
    @tags = Category.all

    respond_to do |format|
      format.json { render json: @tags }
    end
  end

  def posts
    @posts = Post.posts_for_api(params)

    respond_to do |format|
      format.json { render json: @posts }
    end
  end
end
