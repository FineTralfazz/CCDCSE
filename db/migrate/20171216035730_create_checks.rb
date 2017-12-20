class CreateChecks < ActiveRecord::Migration[5.1]
  def change
    create_table :checks do |t|
      t.integer :team_id
      t.integer :service_id
      t.boolean :up
      t.integer :points

      t.timestamps
    end
  end
end
