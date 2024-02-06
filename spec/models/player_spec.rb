require 'rails_helper'

RSpec.describe Player, type: :model do
  describe '#get_total_score' do
    it 'returns the total score of a player in the game' do
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

      expect(player1.get_total_score(true)).to eq(200)
      expect(player2.get_total_score(true)).to eq(89)
    end
  end
end
