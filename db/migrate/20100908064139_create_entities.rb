class CreateEntities < ActiveRecord::Migration
  def self.up
    create_table :entities do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :entities
  end
end
