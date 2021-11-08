class CreateTeams < ActiveRecord::Migration[6.1]
  def change
    create_table :teams do |t|
      t.text :title
      t.references :country, foreign_key: true
      t.integer :rating

      t.timestamps
    end
  end
end
