require "./config/environment"
require 'sinatra'

class ApplicationController < Sinatra::Base
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "ToDo secret"
    register Sinatra::Flash
  end
  before do
    if (['/users/signin', '/users/new'].any? request.path_info) && !session['user_id'].nil?
      redirect('/todos/list')
    end

    if (['/users/signin', '/users/new'].none? request.path_info) && session['user_id'].nil?
      redirect('/users/signin')
    end


  end

  get "/" do
    erb :'users/signin'

  end
  
  def logged_in?
    !!current_user 
  end

  def current_user
    @current_user ||= User.find(session['user_id']) if session['user_id']
  end
end


