class CreateActivities < ActiveRecord::Migration[7.1]
  def change
    create_table :activities do |t|
      t.string     :activity_type, null: false   # call email meeting note task stage_change
      t.string     :subject,       null: false
      t.text       :description
      t.boolean    :completed,     default: false
      t.datetime   :scheduled_at
      t.references :user,    foreign_key: true, null: true
      t.references :contact, foreign_key: true, null: true
      t.references :deal,    foreign_key: true, null: true

      t.timestamps
    end

    add_index :activities, :activity_type
  end
end
