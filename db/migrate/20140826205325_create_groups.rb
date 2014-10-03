class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.integer :facebook_id, :limit => 8

      t.timestamps
    end
  end
end
