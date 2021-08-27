class CreateUsuarios < ActiveRecord::Migration[6.1]
  def change
    create_table :usuarios do |t|
      t.string :email, null: false, index: { unique: true, name: 'unique_emails' }
      t.string :nombre, null: false

      t.timestamps
    end
  end
end
