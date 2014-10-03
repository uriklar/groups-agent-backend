class CreateGroupsRequestsTable < ActiveRecord::Migration
  def self.up
    create_table :groups_requests, :id => false do |t|
      t.references :group
      t.references :request
    end
    add_index :groups_requests, [:group_id, :request_id]
    add_index :groups_requests, :request_id
  end

  def self.down
    drop_table :groups_requests
  end
end
