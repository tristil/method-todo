class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name
      t.datetime :deleted_at
      t.references :user
      t.timestamps
    end
  end
end
