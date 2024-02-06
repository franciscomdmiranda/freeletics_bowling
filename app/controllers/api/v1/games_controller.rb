class Api::V1::GamesController < ApplicationController

=begin
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{"players":["Player1","Player2"]}' \
  http://localhost:3000/api/v1/games/start_game
=end
  def start_game
    game = Game.create
    start_game = game.start_game(params[:players])

    puts "\nThere was an issue with the curl request, please check the parameters.\n" if !start_game
    render json: game
  end

=begin
curl -X GET http://localhost:3000/api/v1/games/1/get_game_score

in this case, 1 is the game.id
=end
  def get_game_score
    game = Game.find(params[:id])
    game.get_game_score if game.present?

    puts "\nThere was an issue with the curl request, please check the parameters.\n" if game.blank?
    render json: game
  end
end
