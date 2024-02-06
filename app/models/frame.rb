class Frame < ApplicationRecord
  belongs_to :player
  belongs_to :game

  validates :number, presence: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }
  validates :throw1, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }, allow_nil: true
  validates :throw2, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }, allow_nil: true
  validates :throw3, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }, allow_nil: true

=begin
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{
        "game_id": 1,
        "player_name": "Player1",
        "frame_number": 1,
        "throw1": 7,
        "throw2": 2
      }' \
  http://localhost:3000/api/v1/frames/throw_ball
=end
  def throw_ball(throw1, throw2, throw3=nil)	#to_i will cover the scenario where if there is no value on throw1 or throw2, it will default to 0. throw3 is being checked for being present as frame 10 is the only frame that can have it and when doing the curl request may forget to add it to the post request body
    if self.throw1.present?		#wont allow to play again on the same frame after it has already been played.
      puts "\nThis frame has already been played.\n"
      return
    end

    previous_frame = get_previous_frame

    if previous_frame.present? && previous_frame.throw1.nil?	#will not allow to play on frame 2 if frame 1 is still to be played, did not implement a too complicated logic for this such as checking if both players have played the same frame number, etc
      puts "\nPlease play on the previous frame: #{previous_frame.id}\n"
      return
    end

    self.throw1 = throw1.to_i

    if number < 10
      if throw3.present?
        puts"\nPlease remove the value of throw3: #{throw3}.\n"
        return
      end

      if is_strike?
        self.throw2 = 0 	#even if another value is set in the post body, throw2 will be defaulted to 0 in case of a strike

        puts"\nStrike!\n"
      elsif is_throw2_valid?(throw2)
        self.throw2 = throw2.to_i

        puts"\nSpare!\n" if is_spare?
      else
        puts"\nInvalid throw 2 input: #{throw2}.\n"
        return
      end

    else

      if is_strike? && throw3.present?
        puts"\nStrike!\n"
        if throw3.present? && (is_strike_2? || (!is_strike_2? && is_throw3_valid?(throw3)))
          self.throw2 = throw2.to_i
          self.throw3 = throw3.to_i

          puts"\nStrike!\n" if is_strike_2?
          puts"\nStrike!\n" if is_strike_3?
          puts"\nSpare!\n" if is_spare_3?
        else
          puts"\nInvalid throw 3 input1: #{throw3}.\n"
          return
        end

      elsif is_throw2_valid?(throw2)
        self.throw2 = throw2.to_i

        if is_spare? && throw3.present?
          self.throw3 = throw3.to_i

          puts"\nSpare!\n"
          puts"\nStrike!\n" if is_strike_3?
        else
          puts"\nInvalid throw 3 input: #{throw3}.\n"
          return
        end
      else
        puts"\nInvalid throws input: throw1: #{throw1}, throw2: #{throw2}, throw3: #{throw3}.\n"
        return
      end
    end

    self.score = calculate_score
    self.save

    puts"\nFrame #{number} score: #{score}.\n"
  end

  def update_score_previous_frame
    previous_frame = get_previous_frame

    return unless previous_frame.present?

    if previous_frame.is_strike_or_spare?
      if previous_frame.is_strike?
        new_score = previous_frame.score.to_i + self.throw1 + self.throw2
      elsif previous_frame.is_spare?
        new_score = previous_frame.score.to_i + self.throw1
      end

      previous_frame.update(score: new_score)
    end
  end

  def calculate_score
    throw1.to_i + throw2.to_i + throw3.to_i
  end

  private

  def get_previous_frame
    previous_frame = Frame.find_by(game_id: game_id, player_id: player_id, number: (number - 1))
  end

  def is_strike_or_spare?
    is_strike? || is_spare?
  end

  def is_strike?
    throw1 == 10
  end

  def is_strike_2?
    throw2 == 10
  end

  def is_strike_3?
    throw3 == 10
  end

  def is_spare?
    !is_strike? && ((throw1.to_i + throw2.to_i) == 10)
  end

  def is_spare_3?
    !is_strike2? && ((throw2.to_i + throw3.to_i) == 10)
  end

  def is_throw2_valid?(throw2)
    (10 - self.throw1.to_i) >= throw2.to_i
  end

  def is_throw3_valid?(throw3)
    (10 - self.throw2.to_i) >= throw3.to_i
  end
end
