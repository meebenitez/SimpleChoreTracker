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
    now = Time.now()

    @chores.each do |chore|
      if now > chore.reset_time
        chore.status = "not done"
        if chore.frequency == "daily" && chore.status == "not done"
          @daily_chores << chore
        elsif chore.frequency == "weekly" && chore.status == "not done"
          @weekly_chores << chore
        elsif chore.frequency == "biweekly" && chore.status == "not done"
          @biweekly_chores << chore
        else
          @monthly_chores << chore
        end
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
    @chore.status = "not done"
    @chore.reset_time = Time.now()
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

  post "/chores/:id/complete" do
    now = Time.now()
    subract_time = 0
    @chore = Chore.find_by_id(params[:id])
   if logged_in? && @chore.user_id == current_user.id
     @chore.status = "done"
     subtract_time = (now.strftime('%H').to_i * 3600) + (now.strftime('%M').to_i * 60) + (now.strftime('%S').to_i)
     @chore.reset_time = now + (86400 - subtract_time)
     @chore.save
     redirect "/chores"
   else
     redirect '/login'
   end
  end

  # DELETE: /chores/5/delete
  delete "/chores/:id/delete" do
    redirect "/chores"
  end
end
