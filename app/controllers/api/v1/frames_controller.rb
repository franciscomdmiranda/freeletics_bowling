class Api::V1::FramesController < ApplicationController

=begin
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{
        "game_id": 1,
        "player_name": "Player1",
        "frame_number": 1,
        "throw1": 2,
        "throw2": 3
      }' \
  http://localhost:3000/api/v1/frames/throw_ball
=end
  def throw_ball
    player = Player.find_by(name: params[:player_name], game_id: params[:game_id])
    frame = Frame.find_by(game_id: params[:game_id], player_id: player.id, number: params[:frame_number]) if player.present?
    
    if frame.present?
      frame.throw_ball(params[:throw1], params[:throw2], params[:throw3])
      frame.update_score_previous_frame
    end

    puts "\nThere was an issue with the curl request, please check the parameters.\n" if player.blank? || frame.blank?
    render json: frame
  end
end
