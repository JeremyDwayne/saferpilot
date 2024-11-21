class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks, id: :string do |t|
      t.string :name
      t.string :acs_code
      t.text :description
      t.string :category

      t.timestamps
    end
  end
end
