# frozen_string_literal: true

class CreateClients < ActiveRecord::Migration[7.1]
  def change
    create_table :clients, id: :uuid do |t|
      t.string :name, null: false
      t.string :hashed_secret, null: false
      t.boolean :public, null: false, default: false
      t.timestamps
    end

    add_index :clients, :name, unique: true
  end
end
