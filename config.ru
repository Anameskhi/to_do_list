require_relative './config/environment'
require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'

use Rack::MethodOverride
run ApplicationController
use UsersController
# use AuthController
use TodosController
# use ListController