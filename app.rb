require 'sinatra'
require_relative "hangman.rb"
	enable :sessions
	get '/' do
	erb :index
end
	post '/user_names' do
	player1 = params[:user_1]
	player2 = params[:user_2]
	"Player 1 is #{player1} and Player 2 is #{player2}!"	
	redirect '/password?player1=' + player1 +'&player2='+ player2
end
	get '/password' do
	player1 = params[:player1]
	player2 = params[:player2]
	erb :password, locals: {p1_name: player1, p2_name: player2}
end
	post '/secretword' do
	password = params[:word]
	session[:game] = Hangman.new(password)
	player1 = params[:player1]
	player2 = params[:player2]
	
	redirect '/guessing'
end
	get '/guessing' do
	player1 = params[:player1] 
	player2 = params[:player2]
	erb :guessing, locals: {p1_name: player1, p2_name: player2, blank: session[:game].correct_blank, array: session[:game].guessed,message: "pick a letter"}
end
	post '/guess' do
	choice = params[:letter].upcase
	player1 = params[:player1] 
	player2 = params[:player2]
	if session[:game].already_guessed(choice) == true
		session[:game].make_move(choice)
		session[:game].update_guessed(choice)
		
		if 
		 session[:game].winner
		 redirect '/winner'
		elsif
		 	 session[:game].lose == true
			redirect '/lose'
		end
		redirect '/guessing'
	else

		erb :guessing, locals: {p1_name: player1, p2_name: player2, blank: session[:game].correct_blank, array: session[:game].guessed,message: "thats already been picked"}
	end
end
 get "/lose" do
 	player1 = params[:player1]
	player2 = params[:player2]
 	erb :lose, locals: {p1_name: player1, p2_name: player2, word: session[:game].name,counter:session[:game].counter}
 	
 end
 get "/winner" do
 	player1 = params[:player1]
	player2 = params[:player2]
 	erb :winner, locals: {p1_name: player1, p2_name: player2, word: session[:game].name,counter:session[:game].counter}
 end