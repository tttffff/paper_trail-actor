ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define do
  create_table :admins, force: true do |t|
    t.string :name
  end

  create_table :orders, force: true do |t|
    t.string :order_number
    t.integer :total
  end

  create_table :products, force: true do |t|
    t.string :name
    t.integer :price_in_cents
  end

  version_column_setter = ->(t) do
    t.string :item_type, null: false
    t.integer :item_id, null: false
    t.string :event, null: false
    t.string :whodunnit
    t.text :object, limit: 1_073_741_823
    t.datetime :created_at
  end

  create_table :versions, force: true, &version_column_setter

  create_table :product_versions, force: true, &version_column_setter
end

ActiveRecord::Migration.verbose = true
