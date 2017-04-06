require 'sinatra'
require 'sinatra/reloader'

configure do
  enable :sessions
  # set :session_secret, "whaaa?"
end

get '/' do
  'Hello, World!!!'
end

post '/guess' do
  # erb :check_guess, :locals => {:current_guess => params['guess'], :correct_guess => session[:correct_number]}

  case
    when params['guess'].to_i == session[:correct_number]
      erb :correct_guess, :locals => {:guess => params['guess'], :response => "good job!", :guesses => session[:guess_count]}
    when session[:guess_count] >= 9
      erb :failed, :locals => {:correct_number => session[:correct_number]}
    when !is_a_number?(params['guess'])
      session[:guess_count] += 1
      erb :check_guess, :locals => {:guess => params['guess'], :response => "not an integer, dummy!", :guesses => session[:guess_count]}
    when params['guess'].to_i > session[:correct_number]
      session[:guess_count] += 1
      erb :check_guess, :locals => {:guess => params['guess'], :response => "too high!", :guesses => session[:guess_count]}
    when params['guess'].to_i < session[:correct_number]
      session[:guess_count] += 1
      erb :check_guess, :locals => {:guess => params['guess'], :response => "too low!", :guesses => session[:guess_count]}
  end
end

post '/new_number' do
  session[:correct_number] = rand(100)
  session[:guess_count] = 0
  redirect to('/guess')
end

get '/guess' do
  erb :guess
end

def is_a_number? string
  string.to_i.to_s == string
end