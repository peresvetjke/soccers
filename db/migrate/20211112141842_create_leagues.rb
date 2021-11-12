class CreateLeagues < ActiveRecord::Migration[6.1]
  def change
    create_table :leagues do |t|
      t.references :country, null: true, foreign_key: true
      t.text :title
      t.text :url

      t.timestamps
    end
  end
end
