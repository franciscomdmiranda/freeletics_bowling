class CreateFrames < ActiveRecord::Migration[7.0]
  def change
    create_table :frames do |t|
      t.integer :number
      t.integer :throw1
      t.integer :throw2
      t.integer :throw3
      t.integer :score
      
      t.references :player, foreign_key: true
      t.references :game, foreign_key: true

      t.timestamps
    end
  end
end
