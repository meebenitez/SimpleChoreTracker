require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "password_security"
  end

  get '/' do
   if logged_in?
     redirect '/chores'
   else
     erb :index
   end
 end

 helpers do
   def logged_in?
     !!session[:user_id]
   end

   def test_instance
     @flag = "test"
   end

   def current_user
     User.find(session[:user_id])
   end

   def valid_email?(email)
	    valid = '[A-Za-z\d.+-]+'
	     (email =~ /#{valid}@#{valid}\.#{valid}/) == 0
	 end

   def slice_count(list_count)
     if list_count.even? && list_count > 8
       slice = list_count / 2
     elsif list_count.odd? && list_count > 8
       list_count = (list_count + 1) / 2
     else
       list_count = 4
     end
   end

   def set_reset(now, frequency)
     daily_seconds = 86400
     biweekly_seconds = 259200
     weekly_seconds = 604800
     monthly_seconds = 2592000
     subtract_time = (now.strftime('%H').to_i * 3600) + (now.strftime('%M').to_i * 60) + (now.strftime('%S').to_i)
     if frequency == "daily"
       reset_time = now - subtract_time + daily_seconds
     elsif frequency == "biweekly"
       reset_time = now - subtract_time + biweekly_seconds
     elsif frequency == "weekly"
       reset_time = now - subtract_time + weekly_seconds
     else
       reset_time = now - subtract_time + monthly_seconds
     end
   end

   def starter_chores
     chores_list = {
       "Make bed" => {
         :frequency => "daily",
         :status => "not done",
         :past_due => "false"
       },
       "Do the dishes" => {
         :frequency => "daily",
         :status => "not done",
         :past_due => "false"
       },
       "Take out the trash" => {
         :frequency => "daily",
         :status => "not done",
         :past_due => "false"
       },
       "Wipe down stove and kitchen countertops" => {
         :frequency => "daily",
         :status => "not done",
         :past_due => "false"
       },
       "Wipe down dining table" => {
         :frequency => "daily",
         :status => "not done",
         :past_due => "false"
       },
       "Wipe down bathroom counters" => {
         :frequency => "daily",
         :status => "not done",
         :past_due => "false"
       },
       "10 minute tidy living room" => {
         :frequency => "daily",
         :status => "not done",
         :past_due => "false"
       },
       "10 minute tidy bedrooms" => {
         :frequency => "daily",
         :status => "not done",
         :past_due => "false"
       },
       "Tidy desk" => {
         :frequency => "biweekly",
         :status => "not done",
         :past_due => "false"
       },
       "Complete a load of laundry" => {
         :frequency => "biweekly",
         :status => "not done",
         :past_due => "false"
       },
       "Pay bills" => {
         :frequency => "biweekly",
         :status => "not done",
         :past_due => "false"
       },
       "Vacuum or sweep all floors" => {
         :frequency => "weekly",
         :status => "not done",
         :past_due => "false"
       },
       "Mop hard floors" => {
         :frequency => "weekly",
         :status => "not done",
         :past_due => "false"
       },
       "Dust all surfaces" => {
         :frequency => "weekly",
         :status => "not done",
         :past_due => "false"
       },
       "Thoroughly clean all bathrooms" => {
         :frequency => "weekly",
         :status => "not done",
         :past_due => "false"
       },
       "Clean out expired fridge items" => {
         :frequency => "weekly",
         :status => "not done",
         :past_due => "false"
       },
       "Wipe down kitchen cabinets and appliances" => {
         :frequency => "weekly",
         :status => "not done",
         :past_due => "false"
       },
       "Wash all bedding" => {
         :frequency => "monthly",
         :status => "not done",
         :past_due => "false"
       },
       "Clean the inside of the oven" => {
         :frequency => "monthly",
         :status => "not done",
         :past_due => "false"
       },
       "Wipe down baseboards, moldings, doors" => {
         :frequency => "monthly",
         :status => "not done",
         :past_due => "false"
       },
       "Wash ceiling light fixtures, wipe fan blades" => {
         :frequency => "monthly",
         :status => "not done",
         :past_due => "false"
       },
       "Dust, vacuum or wash window coverings" => {
         :frequency => "monthly",
         :status => "not done",
         :past_due => "false"
       },
       "Wipe light switches and door handles" => {
         :frequency => "monthly",
         :status => "not done",
         :past_due => "false"
       }
     }
     now = Time.now()
     @user = current_user
     #subtract_time = (now.strftime('%H').to_i * 3600) + (now.strftime('%M').to_i * 60) + (now.strftime('%S').to_i)
     #reset_time = now - subtract_time
     chores_list.each do |name, chore_hash|
       p = Chore.new
       p.name = name
       p.past_due = false
       chore_hash.each do |attribute, value|
         p[attribute] = value
       end
       p.reset_time = set_reset(now, p.frequency)
       @user.chores << p
       p.save
     end
   end

 end

end
