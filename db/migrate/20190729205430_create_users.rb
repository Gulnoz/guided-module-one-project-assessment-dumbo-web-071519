class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :password
      t.integer :age
      t.string :relationship_status
      t.date :birthday
    end
  end
end
