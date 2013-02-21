class CreateResourceGrades < ActiveRecord::Migration
  def self.up
    create_table :resource_grades do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :resource_grades
  end
end
