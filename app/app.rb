ENV["RACK_ENV"] ||= "development"

require 'sinatra/base'
require_relative 'data_mapper_setup'

# require 'sinatra/flash'

class Chitter < Sinatra::Base

  enable :sessions
  set :session_secret, 'super secret'

  get '/peeps' do
    @peeps = Peep.all
    erb :'peeps/index'
  end

  get '/peeps/new' do
    erb :'peeps/new'
  end

  post '/peeps' do
    Peep.create(message: params[:message])
    redirect '/peeps'
  end

  get '/users/new' do
    erb :'users/new'
  end

  post '/users' do
    user = User.create(name: params[:name], nickname: params[:nickname],
                      email: params[:email], password: params[:password],
                      password_confirmation: params[:password_confirmation])
    session[:user_id] = user.id
    redirect to('/peeps')
  end

  helpers do
    def current_user
      @current_user ||= User.get(session[:user_id])
    end
  end

run! if app_file == $0
end
