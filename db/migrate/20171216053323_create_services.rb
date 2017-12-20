class CreateServices < ActiveRecord::Migration[5.1]
  def change
    create_table :services do |t|
      t.string :name
      t.string :protocol
      t.string :address
      t.integer :port

      t.timestamps
    end
  end
end
