class CreateKeywordsRequestsTable < ActiveRecord::Migration
  def self.up
    create_table :keywords_requests, :id => false do |t|
      t.references :keyword
      t.references :request
    end
    add_index :keywords_requests, [:keyword_id, :request_id]
    add_index :keywords_requests, :request_id
  end

  def self.down
    drop_table :keywords_requests
  end
end
