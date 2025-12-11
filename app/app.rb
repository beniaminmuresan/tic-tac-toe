# frozen_string_literal: true

require 'sinatra/base'
require 'json'
require_relative '../lib/game'

# Main application controller
class TicTacToeApp < Sinatra::Base
  enable :sessions
  set :session_secret, ENV.fetch('SESSION_SECRET', SecureRandom.hex(32))
  set :views, File.expand_path('../views', __dir__)
  set :public_folder, File.expand_path('../public', __dir__)

  get '/' do
    erb :index
  end

  post '/start' do
    content_type :json
    user_symbol = params[:symbol]
    session[:game] = Game.new(user_symbol)
    session[:game].to_hash.to_json
  end

  post '/move' do
    content_type :json
    game = session[:game]

    return { error: 'No game in progress' }.to_json if game.nil?

    row = params[:row].to_i
    col = params[:col].to_i

    if game.make_move(row, col, game.user_symbol)
      game.computer_move unless game.game_over
    end

    session[:game] = game
    game.to_hash.to_json
  end

  get '/reset' do
    session.clear
    redirect '/'
  end
end
