class TodosController < ApplicationController

  get '/todos/todo' do 

    erb :'todo/todo'
  end

  
end