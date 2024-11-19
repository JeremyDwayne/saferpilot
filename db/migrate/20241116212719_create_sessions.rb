class CreateSessions < ActiveRecord::Migration[8.0]
  def change
    create_table :sessions, id: false do |t|
      t.string :id, null: false, primary_key: true
      t.references :user, null: false, foreign_key: true, type: :string
      t.string :ip_address
      t.string :user_agent

      t.timestamps
    end
    add_index :sessions, :id, unique: true
  end
end
