class CreateCommodityLists < ActiveRecord::Migration
  def self.up
    create_table :commodity_lists do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :commodity_lists
  end
end
