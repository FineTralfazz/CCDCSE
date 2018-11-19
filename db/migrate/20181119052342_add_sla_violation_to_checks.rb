class AddSlaViolationToChecks < ActiveRecord::Migration[5.1]
  def change
    add_column :checks, :sla_violation, :boolean
  end
end
