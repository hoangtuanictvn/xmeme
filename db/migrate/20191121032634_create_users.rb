class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :uname
      t.string :picture
      t.string :email
      t.string :password_digest
      t.string :remember_digest

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
