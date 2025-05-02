class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string  :name,        null: false
      t.text    :description, null: false
      t.decimal :price,       null: false, precision: 10, scale: 2
      t.boolean :available,   default: true

      t.timestamps
    end
  end
end
