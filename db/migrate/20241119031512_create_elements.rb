class CreateElements < ActiveRecord::Migration[8.0]
  def change
    create_table :elements do |t|
      t.text :description
      t.string :code

      t.timestamps
    end
  end
end
