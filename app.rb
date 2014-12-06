require 'sinatra'
require 'sinatra/redis'
require 'resque'

require 'omniauth'
require 'omniauth-twitter'
require 'omniauth-vkontakte'

require './lib/connection'
require './lib/check_submission'

require './models/user'
require './models/task'
require './models/task_sample'
require './models/task_tag'
require './models/submission'

configure do
  enable :sessions
  set :session_secret, '*&(^B234asdasd228'
  Connection.connect_db(ENV['RACK_ENV'])

  use OmniAuth::Builder do
    provider :twitter, 'oSu9QoZsGBDQg5GxhCYbV3y3P', 'wtfjYpB0f1CuL5sfhfRsb0YbSVCv3QgYo8qmyZHrrZL5Hevguc'
    provider :vkontakte, '4576656', 'kvVlWfH8WOyIVPGVGVNk'
  end

  redis_url = "redis://localhost:6379/"  
  uri = URI.parse(redis_url)
  Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
  Resque.redis.namespace = "resque"
  set :redis, redis_url

end

helpers do
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end

before do
  current_user
end

get '/' do
  erb :home
end

get '/tasks/?' do
  @tasks = Task.all
  erb :tasks
end

get '/task/:id/?' do
  @task = Task.find(params[:id])
  @tags = @task.task_tags
  @samples = @task.task_samples
  erb :task
end

get '/suggest_task/?' do
  offset = rand(Task.count)
  task = Task.offset(offset).first
  redirect "/task/#{task.id}"
end

post '/submit/:id/?' do
  @task = Task.find(params[:id])
  unless params['file'].nil?
    code = params['file'][:tempfile].read
  else
    code = params[:code]
  end
  p code
  @submission = @task.submissions.create(:user_id => @current_user.id, :code => code, :lang => params[:lang])

  Resque.enqueue(CheckSubmission, @submission.id)
  redirect '/submissions'
end

get '/submissions' do
  @submissions = @current_user.submissions
  erb :submissions
end

get '/auth/:name/callback' do
  auth = request.env['omniauth.auth']
  user = User.find_by(:uid => auth["uid"], :provider => auth["provider"]) || User.create({
    :uid => auth["uid"],
    :provider => auth["provider"],
    :name => auth["info"]["name"],
    :logo => auth["info"]["image"] })
  session[:user_id] = user.id
  redirect '/'
end

get '/sign_out/?' do
  session[:user_id] = nil
  redirect '/'
end
