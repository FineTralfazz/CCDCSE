class AddDetailsToCheck < ActiveRecord::Migration[5.1]
  def change
    add_column :checks, :details, :string
  end
end
