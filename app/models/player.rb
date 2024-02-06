class Player < ApplicationRecord
  has_many :frames
  belongs_to :game
  validates :name, presence: true

  #test_output_bool param set as true in the tests only so the console is not overflooded with puts
  def get_total_score(test_output_bool=false)
    total_score = 0
    frames = Frame.where(game_id: game_id, player_id: id)

    if frames.present?
      frames.each do |frame|
        break if frame.score.nil?  #no need to iterate the rest of the frames if the current still has no values as there is a validation for only allowing to input values in the frames by their order.
        
        puts"Frame #{frame.number} score: #{frame.score}.\n" if !test_output_bool
        
        total_score += frame.score.to_i
      end
    end

    total_score
  end
end