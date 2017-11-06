class ChoresController < ApplicationController
  require 'pry'

  # GET: /chores
  get "/chores" do
    if logged_in?
      now = Time.now()
      @user = current_user
      @daily_chores = []
      @weekly_chores = []
      @biweekly_chores = []
      @monthly_chores = []
      #add logic for daily, weekly, monthly
      @chores = @user.chores
      now = Time.now()
      @chores.each do |chore|
        if chore.frequency == "daily" && chore.status == "not done"
          if now > chore.reset_time
            chore.past_due = true
          end
          @daily_chores << chore
          @daily_chores_count = slice_count(@daily_chores.count)
        elsif chore.frequency == "weekly" && chore.status == "not done"
          if now > chore.reset_time
            chore.past_due = true
          end
          @weekly_chores << chore
          @weekly_chores_count = slice_count(@weekly_chores.count)
        elsif chore.frequency == "biweekly" && chore.status == "not done"
          if now > chore.reset_time
            chore.past_due = true
          end
          @biweekly_chores << chore
          @biweekly_chores_count = slice_count(@biweekly_chores.count)
        else
          if now > chore.reset_time
            chore.past_due = true
          end
          @monthly_chores << chore
          @monthly_chores_count = slice_count(@monthly_chores.count)
        end
      end
      erb :"/chores/index.html"
    else
      redirect '/login'
    end

  end

  # GET: /chores/new
  get "/chores/new" do
    if logged_in?
      erb :"/chores/new.html"
    else
      redirect '/login'
    end
  end

  get "/chores/seed" do
    if logged_in?
      starter_chores
      redirect '/chores/new_user'
    else
      redirect '/login'
    end
  end


  get "/chores/new_user" do
    if logged_in?
      now = Time.now()
      @user = current_user
      @daily_chores = []
      @weekly_chores = []
      @biweekly_chores = []
      @monthly_chores = []
      #add logic for daily, weekly, monthly
      @chores = @user.chores
      now = Time.now()
      @chores.each do |chore|
        if chore.frequency == "daily" && chore.status == "not done"
          if now > chore.reset_time
            chore.past_due = true
          end
          @daily_chores << chore
          @daily_chores_count = slice_count(@daily_chores.count)
        elsif chore.frequency == "weekly" && chore.status == "not done"
          if now > chore.reset_time
            chore.past_due = true
          end
          @weekly_chores << chore
          @weekly_chores_count = slice_count(@weekly_chores.count)
        elsif chore.frequency == "biweekly" && chore.status == "not done"
          if now > chore.reset_time
            chore.past_due = true
          end
          @biweekly_chores << chore
          @biweekly_chores_count = slice_count(@biweekly_chores.count)
        else
          if now > chore.reset_time
            chore.past_due = true
          end
          @monthly_chores << chore
          @monthly_chores_count = slice_count(@monthly_chores.count)
        end
      end
      erb :"/chores/new_user.html"
    else
      redirect '/login'
    end
  end

  # POST: /chores
  post "/chores" do
    now = Time.now()
    @user = current_user
    if params[:chore] != ""
      @chore = Chore.create(name: params[:name], frequency: params[:frequency])
      @chore.status = "not done"
      @chore.reset_time = set_reset(now, @chore.frequency)
      @chore.past_due = false
      @user.chores << @chore
      @user.save
    else
      redirect '/chores/new'
    end
      redirect '/chores'
    end

  get "/chores/edit" do
    if logged_in?
      @user = current_user
      @daily_chores = []
      @weekly_chores = []
      @biweekly_chores = []
      @monthly_chores = []
      #add logic for daily, weekly, monthly
      @chores = @user.chores

      @chores.each do |chore|
        if chore.frequency == "daily"
          @daily_chores << chore
          @daily_chores_count = slice_count(@daily_chores.count)
        elsif chore.frequency == "weekly"
          @weekly_chores << chore
          @weekly_chores_count = slice_count(@weekly_chores.count)
        elsif chore.frequency == "biweekly"
          @biweekly_chores << chore
          @biweekly_chores_count = slice_count(@biweekly_chores.count)
        else
          @monthly_chores << chore
          @monthly_chores_count = slice_count(@monthly_chores.count)
        end
      end
      erb :"chores/list_edit.html"
    else
      redirect '/login'
    end
  end

  # GET: /chores/5
  get "/chores/:id" do
    @chore = Chore.find_by_id(params[:id])
    if logged_in?
      erb :"chores/show.html"
    else
      redirect to '/login'
    end
  end

  # GET: /chores/5/edit
  get '/chores/:id/edit' do
    @chore = Chore.find_by_id(params[:id])
   if logged_in? && @chore.user_id == current_user.id
     erb :"chores/edit.html"
   else
     redirect '/login'
   end
  end

  # PATCH: /chores/5
  post '/chores/:id' do
    @chore = Chore.find_by_id(params[:id])
    if logged_in? && @chore.user_id == current_user.id
      if params[:name] == ""
        redirect "/chores/#{@chore.id}/edit"
      else
        @chore.update(name: params[:name])
        @chore.save
        redirect "/chores/edit"
      end
    elsif logged_in? && @chore.user_id != current_user.id
      redirect '/chores'
    else
      redirect '/login'
    end
  end

  post "/chores/:id/complete" do
    now = Time.now()
    @chore = Chore.find_by_id(params[:id])
   if logged_in? && @chore.user_id == current_user.id
     @chore.status = "done"
     @chore.reset_time = set_reset(now, @chore.frequency)
     @chore.save
     redirect "/chores"
   else
     redirect '/login'
   end
  end

  # DELETE: /chores/5/delete
  get "/chores/:id/delete" do
    @chore = Chore.find_by_id(params[:id])
    if logged_in? && @chore.user_id == current_user.id
      @chore.delete
      redirect '/chores/edit'
    elsif logged_in? && @chore.user_id != current_user.id
      redirect "/chores/edit"
    else
      redirect '/login'
    end
  end
end
