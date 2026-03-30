class CreateCompanies < ActiveRecord::Migration[7.1]
  def change
    create_table :companies do |t|
      t.string  :name,     null: false
      t.string  :industry
      t.string  :website
      t.string  :phone
      t.string  :address
      t.string  :city
      t.string  :country
      t.integer :size,     default: 1    # 0=startup 1=small 2=medium 3=large 4=enterprise
      t.text    :notes

      t.timestamps
    end

    add_index :companies, :name, unique: true
  end
end
