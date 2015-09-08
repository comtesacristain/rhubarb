class CreateDeposits < ActiveRecord::Migration
  def self.up
    create_table "a.entities" do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table "a.entities"
  end
end
