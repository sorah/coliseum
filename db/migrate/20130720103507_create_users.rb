class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :provider
      t.string :uid
      t.string :name
      t.string :nick
      t.string :image_url
      t.string :auth_token
      t.string :auth_secret
      t.boolean :staff

      t.index [:provider, :uid]
      t.index :nick

      t.timestamps
    end
  end
end
