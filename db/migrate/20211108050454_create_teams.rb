class CreateTeams < ActiveRecord::Migration[6.1]
  def change
    create_table :countries do |t|
      t.text :title

      t.timestamps
    end

    create_table :teams do |t|
      t.text :title
      t.references :country, null: false, foreign_key: true
      t.integer :rating

      t.timestamps
    end


    create_table :team_aliases do |t|
      t.references :team, null: false, foreign_key: true
      t.text :title
      t.boolean :default

      t.timestamps
    end
  end
end
