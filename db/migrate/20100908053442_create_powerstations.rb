class CreatePowerstations < ActiveRecord::Migration
  def self.up
    create_table :powerstations do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :powerstations
  end
end
