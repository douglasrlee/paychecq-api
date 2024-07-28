# frozen_string_literal: true

class EnableCitext < ActiveRecord::Migration[7.1]
  def change
    enable_extension 'citext'
  end
end
