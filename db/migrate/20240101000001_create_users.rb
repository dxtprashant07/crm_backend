class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string  :name,            null: false
      t.string  :email,           null: false
      t.string  :password_digest, null: false
      t.integer :role,            default: 0, null: false   # 0=agent 1=manager 2=admin
      t.boolean :active,          default: true

      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
