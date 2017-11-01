class UsersController < ApplicationController

  # GET: /users

  get '/signup' do
     if logged_in?
       redirect '/chores'
     else
       erb :"users/new.html"
     end

   end

   post '/signup' do
      if params[:name] == "" || params[:password] == "" || params[:email] == ""
        redirect '/signup'
       else
         @user = User.new(name: params[:name], password: params[:password], email: params[:email])
         @user.save
         session[:user_id] = @user.id
         redirect '/chores'
       end
   end

   get '/login' do
    if logged_in?
      redirect '/chores'
    else
      erb :'users/login.html'
    end
  end

  post '/login' do
    @user = User.find_by(email: params[:email])
      if @user && @user.authenticate(params[:password])
        session[:user_id] = @user.id
        redirect '/chores'
      else
        redirect '/login'
      end
  end

  get '/logout' do
    if logged_in?
      session.clear
      redirect '/login'
    else
      redirect '/'
    end
  end


  get "/users" do
    erb :"/users/index.html"
  end

  # GET: /users/new
  get "/users/new" do
    erb :"/users/new.html"
  end

  # POST: /users
  post "/users" do
    redirect "/users"
  end

  # GET: /users/5
  get "/users/:id" do
    erb :"/users/show.html"
  end

  # GET: /users/5/edit
  get "/users/:id/edit" do
    erb :"/users/edit.html"
  end

  # PATCH: /users/5
  patch "/users/:id" do
    redirect "/users/:id"
  end

  # DELETE: /users/5/delete
  delete "/users/:id/delete" do
    redirect "/users"
  end



end
