class AddCategoryToSubcategory < ActiveRecord::Migration[5.1]
  def change
    add_reference :subcategories, :category, foreign_key: true
  end
end
