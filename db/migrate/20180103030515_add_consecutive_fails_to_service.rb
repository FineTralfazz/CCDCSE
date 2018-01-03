class AddConsecutiveFailsToService < ActiveRecord::Migration[5.1]
  def change
    add_column :services, :consecutive_fails, :integer
  end
end
