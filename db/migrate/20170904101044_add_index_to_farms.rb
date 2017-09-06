class AddIndexToFarms < ActiveRecord::Migration[5.0]
  def change
    add_index :farms, :name
  end
end
