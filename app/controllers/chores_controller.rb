class ChoresController < ApplicationController
  require 'pry'

  # GET: /chores
  get "/chores" do
    @user = current_user
    @daily_chores = []
    @weekly_chores = []
    @biweekly_chores = []
    @monthly_chores = []
    #add logic for daily, weekly, monthly
    @chores = @user.chores

    @chores.each do |chore|
      if chore == "daily"
        @daily_chores << chore
      elsif chore == "weekly"
        @weekly_chores << chore
      elsif chore == "biweekly"
        @biweekly_chores << chore
      else
        @monthly_chores << chore
      end
    end
        
        
    erb :"/chores/index.html"
  end

  # GET: /chores/new
  get "/chores/new" do
    erb :"/chores/new.html"
  end

  # POST: /chores
  post "/chores" do
    @user = current_user
    if params[:chore] != ""
    @chore = Chore.create(name: params[:name], frequency: params[:frequency])
    @user.chores << @chore
    @user.save
  else
    redirect '/chores/new'
  end
    redirect '/chores'
  end

  # GET: /chores/5
  #get "/chores/:id" do
  #  erb :"/chores/show.html"
  #end

  get "/chores/edit" do
    if logged_in?
      @user = current_user
      @chores = @user.chores
      erb :"chores/list_edit.html"
    else
      redirect '/login'
    end
  end

  # GET: /chores/5/edit
  get "/chores/:id/edit" do
    @chore = Chore.find_by_id(params[:id])
   if logged_in? && @chore.user_id == current_user.id
     erb :"chores/edit.html"
   else
     redirect '/login'
   end
  end

  # PATCH: /chores/5
  patch "/chores/:id" do
    @chore = Chore.find_by_id(params[:id])
     if params[:chore] == ""
       redirect "/chores/#{@chore.id}/edit"
     else
       @chore.update(name: params[:name])
       redirect "/chores"
     end
  end

  # DELETE: /chores/5/delete
  delete "/chores/:id/delete" do
    redirect "/chores"
  end
end
