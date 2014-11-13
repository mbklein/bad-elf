class AddClosedToExchanges < ActiveRecord::Migration
  def change
    add_column :exchanges, :closed, :boolean
  end
end
