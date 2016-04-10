class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :asin
      t.string :isbn
      t.string :title
      t.string :binding
      t.text :product_url
      t.text :image_small
      t.text :image_medium
      t.text :image_large
      t.decimal :price, :precision => 20, :scale => 6
      t.string :price_currency
      t.string :group

      t.timestamps null: false
    end
  end
end
