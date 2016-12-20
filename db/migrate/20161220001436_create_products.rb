class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :slug
      t.string :title
      t.decimal :price_net, precision: 11, scale: 2
      t.decimal :price_gross, precision: 11, scale: 2

      t.timestamps
    end
    add_index :products, :slug, unique: true
  end
end
