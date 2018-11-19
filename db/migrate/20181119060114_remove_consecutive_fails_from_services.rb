class RemoveConsecutiveFailsFromServices < ActiveRecord::Migration[5.1]
  def change
    remove_column :services, :consecutive_fails
  end
end
