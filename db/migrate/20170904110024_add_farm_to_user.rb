class AddFarmToUser < ActiveRecord::Migration[5.0]
  def change
    add_reference :users, :farm, index: true
    add_foreign_key :users, :farms
  end
end
