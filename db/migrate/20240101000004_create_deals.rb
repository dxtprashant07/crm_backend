class CreateDeals < ActiveRecord::Migration[7.1]
  def change
    create_table :deals do |t|
      t.string     :title,               null: false
      t.decimal    :value,               precision: 12, scale: 2, default: 0
      t.string     :stage,               default: "prospecting"
      t.integer    :probability,         default: 10
      t.date       :expected_close_date
      t.text       :notes
      t.references :contact, foreign_key: true, null: true
      t.references :company, foreign_key: true, null: true
      t.bigint     :owner_id
      t.index      :owner_id

      t.timestamps
    end

    add_index :deals, :stage
    add_foreign_key :deals, :users, column: :owner_id
  end
end
