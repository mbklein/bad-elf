class CreateExchanges < ActiveRecord::Migration
  def change
    create_table :exchanges do |t|
      t.string :name
      t.text :description
      t.datetime :deadline
      t.integer :owner_id

      t.timestamps
    end
  end
end
