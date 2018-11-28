class RemovePortFromService < ActiveRecord::Migration[5.1]
  def change
    remove_column :services, :port
  end
end
