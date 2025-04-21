ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: "paper_trail-actor_test"
)

def add_database_actions(rspec_config)
  build_up_database(rspec_config)
  tear_down_database(rspec_config)
end

def build_up_database(rspec_config)
  rspec_config.before(:suite) do
    ActiveRecord::Migration.verbose = false
    ActiveRecord::Schema.define do
      create_table :admins do |t|
        t.string :name
      end

      create_table :orders do |t|
        t.string :order_number
        t.integer :total
      end

      create_table :products do |t|
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

      create_table :versions, &version_column_setter

      create_table :product_versions, &version_column_setter
    end
  end
end

def tear_down_database(rspec_config)
  rspec_config.after(:suite) do
    ActiveRecord::Schema.define do
      drop_table :admins
      drop_table :orders
      drop_table :products
      drop_table :versions
      drop_table :product_versions
    end
    ActiveRecord::Migration.verbose = true
  end
end
