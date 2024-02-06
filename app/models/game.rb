class Game < ApplicationRecord
  has_many :players
  has_many :frames, through: :players

=begin
  curl -X POST \
  -H "Content-Type: application/json" \
  -d '{"players":["Player1","Player2"]}' \
  http://localhost:3000/api/v1/games/start_game
=end
  def start_game(players_array)
    return false if players_array.empty? || players_array.include?(',')

    player_names = players_array.join(',')

    player_names.split(',').each do |player_name|
      player = Player.create(name: player_name, game_id: self.id)

      (1..10).each do |number|
        frame = Frame.create(number: number, player_id: player.id, game_id: self.id)
      end
    end

    puts "\nGame with id: #{self.id} with the players #{player_names} created with success.\nPlease remember the game id\n"

    true
  end

  #test_output_bool param set as true in the tests so the console is not overflooded with puts
  def get_game_score(test_output_bool=false)
    players = Player.where(game_id: id)
    total_score_hash = {}

    if players.present?
      players.each do |player|
      	puts"\nPlayer #{player.name}:\n" if !test_output_bool

      	total_score = player.get_total_score(test_output_bool)
      	total_score_hash[:"#{player.name}"] = total_score
      	
        puts"\nTotal score: #{total_score} points.\n" if !test_output_bool
      end
    end

    total_score_hash
  end
end