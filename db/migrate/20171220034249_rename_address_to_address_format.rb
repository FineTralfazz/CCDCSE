class RenameAddressToAddressFormat < ActiveRecord::Migration[5.1]
  def change
    rename_column :services, :address, :address_format
  end
end
