class CreateTeams < ActiveRecord::Migration[5.1]
  def change
    create_table :teams do |t|
      t.integer :number
      t.string :password_digest
      t.integer :points

      t.timestamps
    end
  end
end
