class CreateContacts < ActiveRecord::Migration[7.1]
  def change
    create_table :contacts do |t|
      t.string     :first_name, null: false
      t.string     :last_name,  null: false
      t.string     :email,      null: false
      t.string     :phone
      t.string     :job_title
      t.integer    :status,     default: 0   # 0=lead 1=prospect 2=customer 3=churned
      t.integer    :source,     default: 5   # 0=website 1=referral 2=cold_outreach 3=social_media 4=event 5=other
      t.text       :notes
      t.references :company, foreign_key: true, null: true

      t.timestamps
    end

    add_index :contacts, :email, unique: true
    add_index :contacts, :status
  end
end
