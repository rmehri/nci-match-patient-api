class CreatePatients < ActiveRecord::Migration
  def change
    create_table :patients do |t|
      t.integer :psn
      t.string :race
      t.string :gender
      t.string :step

      t.timestamps null: false
    end
  end
end
