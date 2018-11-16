class AddArgsToServices < ActiveRecord::Migration[5.1]
  def change
    add_column :services, :arg1, :string
    add_column :services, :arg2, :string
  end
end
