class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.integer :exchange_id
      t.integer :santa_id
      t.integer :recipient_id

      t.timestamps
    end
  end
end
