require "spec_helper"
require_relative "../support/actor"
require_relative "../support/order"
require_relative "../support/product"

module PaperTrailActor
  RSpec.describe VersionConcern do
    include_context "a project with a possible active record actor"

    shared_examples "a paper_trail version that uses paper_trail-actor" do
      describe "#actor" do
        context "when value for whodunnit is object of ActiveRecord" do
          it "returns object" do
            version.whodunnit = admin
            version.save
            expect(version.actor).to eq(admin)
          end
        end

        context "when value for whodunnit is not an object of ActiveRecord" do
          it "returns value itself" do
            version.whodunnit = "test"
            version.save
            expect(version.actor).to eq("test")
          end
        end
      end

      describe "#whodunnit" do
        context "when value for whodunnit is object of ActiveRecord" do
          it "returns global id" do
            version.whodunnit = admin
            version.save
            expect(version.whodunnit).to eq(admin.to_gid.to_s)
          end
        end

        context "when value for whodunnit is not an object of ActiveRecord" do
          it "returns value itself" do
            version.whodunnit = "test"
            version.save
            expect(version.whodunnit).to eq("test")
          end
        end
      end
    end

    context "when using the built in paper_trail version class" do
      let(:order) { Order.create!(order_number: "ord_1", total: 100) }
      let(:version) { order.versions.last }

      it_behaves_like "a paper_trail version that uses paper_trail-actor"
    end

    context "when using a custom version class" do
      let(:product) { Product.create!(name: "Coffee cup", price_in_cents: 1500) }
      let(:version) { product.versions.last }

      it_behaves_like "a paper_trail version that uses paper_trail-actor"
    end
  end
end
