# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users, id: :uuid do |t|
      t.string :name, null: false
      t.citext :email, null: false
      t.string :hashed_password, null: false
      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
