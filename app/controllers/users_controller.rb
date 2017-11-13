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
        @message = "You left a field empty.  Please try again."
        erb :"users/new_error.html"
      elsif User.find_by(email: params[:email])
        @message = "An account already exists with that email.  Please try again."
        erb :"users/new_error.html"
      elsif !User.find_by(email: params[:email]) && !valid_email?(params[:email])
        @message = "You entered an invalid email address.  Please try again."
        erb :"users/new_error.html"
      else
         @user = User.new(name: params[:name], password: params[:password], email: params[:email])
         @user.new_user = true
         @user.save
         session[:user_id] = @user.id
         redirect '/chores/seed'
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
        @message = "You entered an incorrect email or password.  Please try again."
        erb :'users/login.html'
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



  # GET: /users/new
  get "/users/new" do
    erb :"/users/new.html"
  end

end
