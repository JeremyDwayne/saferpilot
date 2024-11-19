class CreateFlights < ActiveRecord::Migration[8.0]
  def change
    create_table :flights, id: :string do |t|
      t.datetime :scheduled_at
      t.references :user, null: false, foreign_key: true, type: :string
      t.boolean :completed
      t.float :total_hours

      t.timestamps
    end
  end
end
