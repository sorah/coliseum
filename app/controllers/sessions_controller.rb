class SessionsController < ApplicationController
  def new
    # TODO
  end

  def destroy
    session[:user_id] = nil
    redirect_to '/'
  end

  def signout
    # TODO
  end

  def auth_failure
    # TODO
  end

  def auth_callback
    auth = env['omniauth.auth']

    user = User.create_with(auth_token: auth.credentials.token,
                            auth_secret: auth.credentials.secret) \
               .find_or_create_by(provider: auth.provider, uid: auth.uid)
    user.update_attributes!(name: auth.info.name, nick: auth.info.nickname,
                            image_url: auth.info.image,)

    session[:user_id] = user.id

    back_to = session[:back_to] || '/'
    session[:back_to] = nil
    unless /^\/[^\/]/ =~ back_to
      back_to = '/'
    end

    redirect_to back_to
  end
end
