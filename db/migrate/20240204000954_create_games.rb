class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.timestamps
    end

    add_reference :games, :player, foreign_key: true
    add_reference :games, :frame, foreign_key: true
  end
end