class TodosController < ApplicationController

  get '/todos/list' do 

    @lists = current_user.list.order("created_at DESC")

    erb :'todo/list'
  end

  post '/todos/list' do
    validate_info = validate_list(params)
    if validate_info.empty?
      List.create(lists_name: params['text'], user_id: current_user['id'] )
      flash[:success_message] = "your list successfully added"
    else
      flash[:error_messages] = validate_info

    end
    redirect('todos/list')
  end

  get '/todos/:id/edit' do
   @list = current_user.list.find_by(id: params['id'])
    erb:'todo/edit'
  end

  post '/todos/:id/edit' do 
    validate_info = validate_list(params)
    if validate_info.empty?
      flash[:success_message] = "your list successfully edited"
      list_edit = List.find(params['id'])
      list_edit.lists_name = params['text']
      list_edit.save
    else
      flash[:error_messages] = validate_info
    end
    redirect("/todos/#{params['id']}/edit")
  end

  get '/todos/:id/delete' do
    @list = current_user.list.find_by(id: params['id'])
    @list.destroy
    flash[:success_message] = "your list successfully deleted"
    redirect("/todos/list")
  end
 
  
  private
   def validate_list(params)
    error_messages = []
    error_messages.push("Window is empty ,input something") if params['text'].strip.empty?
    error_messages.push("name must be unique") if List.find_by(lists_name:params['text'])
    error_messages
   end

 

end