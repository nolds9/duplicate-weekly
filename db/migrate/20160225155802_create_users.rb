class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :sid
      t.string :refresh_token
    end
  end
end
