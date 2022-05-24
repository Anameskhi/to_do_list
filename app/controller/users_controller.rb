class UsersController < ApplicationController

  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i


  get '/users/signin' do 

    erb :'users/signin'
  end

  post '/users/signin' do
    validate_info = validate_user_signin(params)
   
    
    unless validate_info.empty?
      flash[:error_messages] = validate_info
      redirect('/users/signin')
      
    end
    find_user = User.find_by(email: params['email'])

    if !!find_user && BCrypt::Password.new(find_user['password_digest']) == params['password']
      session['user_id'] = find_user['id']
      flash[:success_message] = "Successfully Loggedin"
      redirect('/todos/list')
    else
      flash[:error_messages] = ["Email or Password is inccorect"]
      redirect('/users/signin')
    end


  end

  get '/users/new' do 
    
    erb :'users/new'
  end

  post '/users/new' do
    validate_info = validate_user_registration_input(params)
    if validate_info.empty?
      flash[:success_message] = "you are successfully register"
      User::create(name: params['name'], email: params['email'], password_digest: BCrypt::Password.create(params['password']))
      redirect('/')
    else 
      flash[:error_messages] = validate_info
      redirect('users/new')
    end
    
  end

  get '/users/edit' do 
    @user = User.find(session['user_id'])
    erb :'users/edit'
  end

  post '/users/edit' do
    validate_info = validate_edit_user_info(params)
    if validate_info.empty?
      flash[:success_message] = "your account successfully edited"
      find_user = User.find(session['user_id'])
      find_user.email = params['email']
      find_user.name = params['name']
      find_user.password_digest = BCrypt::Password.create(params['new_password']) if params['new_password'].length > 0
      find_user.save
    else
      flash[:error_messages] = validate_info
    end
    redirect('/users/edit')
  end

  get '/users/deleteaccount' do
   user = User.find(session['user_id'])
   user.destroy
   redirect('users/signout')
end

  get '/users/signout' do
    session['user_id'] = nil
    session.destroy
    redirect('users/signin')
    
  end

  private

  def validate_user_registration_input(params)
   error_messages = []
   error_messages.push("name length isn't  above 2 charachter") unless params['name'].to_s.length > 2
   error_messages.push("email isn't validate") unless params['email'] =~ EMAIL_REGEX
   error_messages.push("password length isn't above 8 charachter")  unless params['password'].to_s.length >= 8 
   error_messages.push("password is not equal confirm password") unless (params['password'] == params['password_confirm'])
   error_messages.push("Email has already been taken") if User.find_by(email: params['email'])
    
   error_messages
  end

  def validate_user_signin(params)
    error_messages = []
    error_messages.push("Email is empty") unless params['email'].length > 0
    error_messages.push("Password is empty") unless params['password'].length > 0

    error_messages
  end

  def validate_edit_user_info(params)
    error_messages = []
    error_messages.push("name length isn't  above 2 charachter") unless params['name'].to_s.length > 2
    error_messages.push("email isn't validate") unless params['email'] =~ EMAIL_REGEX
    if params['new_password'].length > 0 
      error_messages.push("password is equal current password") if params['password'] == params['new_password']
      error_messages.push("New password is not equal confirm password") unless params['new_password'] == params['confirm_password']
    end

    error_messages
  end
end