class CreateHandCards < ActiveRecord::Migration[5.2]
  def change
    create_table :hand_cards do |t|
      t.integer :user_id
      t.integer :card_id
      t.string :date
    end
  end
end
