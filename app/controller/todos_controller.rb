class TodosController < ApplicationController

  get '/todos/show' do 

    erb :'todo/show'
  end
end