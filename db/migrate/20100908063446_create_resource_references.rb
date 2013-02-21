class CreateResourceReferences < ActiveRecord::Migration
  def self.up
    create_table :resource_references do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :resource_references
  end
end
