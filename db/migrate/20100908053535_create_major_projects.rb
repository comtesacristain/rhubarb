class CreateMajorProjects < ActiveRecord::Migration
  def self.up
    create_table :major_projects do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :major_projects
  end
end
