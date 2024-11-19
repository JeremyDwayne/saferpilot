class CreateElements < ActiveRecord::Migration[8.0]
  def change
    create_table :elements, id: false do |t|
      t.string :id, null: false, primary_key: true
      t.text :description
      t.string :code

      t.timestamps
    end
    add_index :elements, :id, unique: true
  end
end
