require "spec_helper"
require_relative "../spec/support/admin"
require_relative "../spec/support/order"
require_relative "../spec/support/product"

RSpec.describe PaperTrailGlobalid do
  before(:all) do
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
  end

  after(:all) do
    ActiveRecord::Schema.define do
      drop_table :admins
      drop_table :orders
      drop_table :products
      drop_table :versions
      drop_table :product_versions
    end
    ActiveRecord::Migration.verbose = true
  end

  describe "paper_trail_globalid" do
    before do
      GlobalID.app = "App"
      @admin = Admin.create(name: "admin")
    end

    describe "request" do
      describe "class_methods" do
        describe ".actor" do
          context "when value for whodunnit is object of ActiveRecord" do
            it "returns object" do
              PaperTrail.request.whodunnit = @admin
              expect(PaperTrail.request.actor).to eq(@admin)
            end
          end

          context "when value for whodunnit is not an object of ActiveRecord" do
            it "returns value itself" do
              PaperTrail.request.whodunnit = "test"
              expect(PaperTrail.request.actor).to eq("test")
            end
          end
        end

        describe ".whodunnit" do
          context "when value for whodunnit is object of ActiveRecord" do
            it "returns global id" do
              PaperTrail.request.whodunnit = @admin
              expect(PaperTrail.request.whodunnit).to eq(@admin.to_gid)
            end
          end

          context "when value for whodunnit is not an object of ActiveRecord" do
            it "returns value itself" do
              PaperTrail.request.whodunnit = "test"
              expect(PaperTrail.request.whodunnit).to eq("test")
            end
          end
        end
      end
    end

    describe "version_concern" do
      describe "instance_methods" do
        shared_examples "a paper_trail version that uses paper_trail_gobalid" do
          describe "#actor" do
            context "when value for whodunnit is object of ActiveRecord" do
              it "returns object" do
                @version.whodunnit = @admin
                @version.save
                expect(@version.actor).to eq(@admin)
              end
            end

            context "when value for whodunnit is not an object of ActiveRecord" do
              it "returns value itself" do
                @version.whodunnit = "test"
                @version.save
                expect(@version.actor).to eq("test")
              end
            end
          end

          describe "#whodunnit" do
            context "when value for whodunnit is object of ActiveRecord" do
              it "returns global id" do
                @version.whodunnit = @admin
                @version.save
                expect(@version.whodunnit).to eq(@admin.to_gid.to_s)
              end
            end

            context "when value for whodunnit is not an object of ActiveRecord" do
              it "returns value itself" do
                @version.whodunnit = "test"
                @version.save
                expect(@version.whodunnit).to eq("test")
              end
            end
          end
        end

        context "when using the built in paper_trail version class" do
          before do
            order = Order.create!(order_number: "ord_1", total: 100)
            @version = order.versions.last
          end

          it_behaves_like "a paper_trail version that uses paper_trail_gobalid"
        end

        context "when using a custom version class" do
          before do
            product = Product.create!(name: "Coffee cup", price_in_cents: 1500)
            @version = product.versions.last
          end

          it_behaves_like "a paper_trail version that uses paper_trail_gobalid"
        end
      end
    end
  end
end
