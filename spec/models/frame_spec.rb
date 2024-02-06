require 'rails_helper'

RSpec.describe Frame, type: :model do
  describe '#throw_ball' do
    it 'returns score of a frame after the throws are done' do
      game = Game.create

      player1 = Player.create(name: 'Player1', game_id: game.id)

      throw1_p1 = 10
      throw2_p1 = 0

      frame1_p1 = Frame.create(number: 1, player_id: player1.id, game_id: game.id)

      expected_output = "\nStrike!\n"+"\nFrame 1 score: 10.\n"

      # Use StringIO to capture the output of puts
      output = StringIO.new
      allow($stdout).to receive(:puts).and_wrap_original do |original_puts, *args|
        output.puts(*args)
      end

      frame1_p1.throw_ball(throw1_p1, throw2_p1)

      expect(output.string).to eq(expected_output)
    end
  end

  describe '#update_score_previous_frame' do
    it 'updates the score of the previous frame in case of a strike or spare' do
      game = Game.create

      player1 = Player.create(name: 'Player1', game_id: game.id)


      frame1_p1 = Frame.create(number: 1, player_id: player1.id, game_id: game.id)
      frame2_p1 = Frame.create(number: 2, player_id: player1.id, game_id: game.id)

      frame1_p1.throw_ball(10, 0)
      frame1_p1.update_score_previous_frame

      expect(frame1_p1.score).to eq(10)

      frame2_p1.throw_ball(7, 2)
      frame2_p1.update_score_previous_frame
      
      frame1_p1 = Frame.find_by(number: 1, player_id: player1.id, game_id: game.id)
      expect(frame1_p1.score).to eq(19)
    end
  end
end
