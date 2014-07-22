class CreateMineralProjects < ActiveRecord::Migration
  def change
    create_table :mineral_projects do |t|

      t.timestamps
    end
  end
end
