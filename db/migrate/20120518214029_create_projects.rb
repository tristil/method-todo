class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.references :user
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
