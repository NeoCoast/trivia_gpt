class AddEndedToRounds < ActiveRecord::Migration[7.0]
  def change
    add_column :rounds, :ended, :boolean, default: false
  end
end
