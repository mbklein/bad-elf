class CreateExchanges < ActiveRecord::Migration
  def change
    create_table :exchanges do |t|
      t.string :name
      t.text :description
      t.date :deadline
      t.integer :owner_id
      t.string :invite_code

      t.timestamps
    end
  end
end
