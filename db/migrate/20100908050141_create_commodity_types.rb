class CreateCommodityTypes < ActiveRecord::Migration
  def self.up
    create_table :commodity_types do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :commodity_types
  end
end
