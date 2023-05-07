class AddEditionIntToResult < ActiveRecord::Migration[7.0]
  def change
    add_column :results, :edition_int, :integer
  end
end
