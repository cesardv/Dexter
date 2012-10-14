class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string :path
      t.string :name
      t.string :avatar
      t.timestamps
    end
  end
end
