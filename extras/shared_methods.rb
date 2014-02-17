module SharedMethods
  def get_app_access_token
    Koala::Facebook::OAuth.new(APP_ID, APP_SECRET).get_app_access_token
  end

  def get_graph
    app_access_token = get_app_access_token
    Koala::Facebook::API.new(app_access_token)
  end
end