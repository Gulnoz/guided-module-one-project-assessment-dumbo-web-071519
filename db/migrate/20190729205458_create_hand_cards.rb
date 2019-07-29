class CreateHandCards < ActiveRecord::Migration[5.2]
  def change
    create_table :hand_cards do |t|
      t.integer :user_id
      t.integer :card_id
      t.datetime :date
    end
  end
end
