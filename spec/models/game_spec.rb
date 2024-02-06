require 'rails_helper'

RSpec.describe Game, type: :model do
  describe '#get_game_score' do
    it 'returns hash with total score of all player in the game' do
      game, player1, player2 = create_game_players_test

      total_scores_hash = {Player1: 200, Player2: 89}

      expect(game.get_game_score(true)).to eq(total_scores_hash)
    end
  end

  describe '#start_game' do
    it 'returns hash with total score of all player in the game' do
      game, player1, player2 = create_game_players_test

      players_array = [player1.name, player2.name]
      player_names = players_array.join(',')

      players = Player.where(game_id: game.id)
      frames = Frame.where(game_id: game.id)

      expect(game.id).to eq(1)
      expect(players.count).to eq(2)
      expect(frames.count).to eq(20)

      expected_console_output = "\nGame with id: #{game.id} with the players #{player_names} created with success.\nPlease remember the game id\n"

      expect { game.start_game(players_array) }.to output(expected_console_output).to_stdout
    end
  end

  def create_game_players_test
    game = Game.create

    player1 = Player.create(name: 'Player1', game_id: game.id)
    player2 = Player.create(name: 'Player2', game_id: game.id)

    (1..10).each do |number|
      if number < 10
        frame = Frame.create(number: number, player_id: player1.id, game_id: game.id, throw1:10, throw2: 0, score: 20)
        frame = Frame.create(number: number, player_id: player2.id, game_id: game.id, throw1: 7, throw2: 2, score: 9)
      else
        frame = Frame.create(number: number, player_id: player1.id, game_id: game.id, throw1:10, throw2: 10, throw3: 0, score: 20)
        frame = Frame.create(number: number, player_id: player2.id, game_id: game.id, throw1: 6, throw2: 2, throw3: nil, score: 8)
      end
    end

    return game, player1, player2
  end
end
