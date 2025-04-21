require "spec_helper"
require_relative "../support/actors"
require_relative "../support/models/order"
require_relative "../support/models/product"

module PaperTrailActor
  RSpec.describe VersionConcern do
    include_context "a project with multiple possible actors"

    shared_examples "a paper_trail version that uses paper_trail-actor" do
      describe "#actor" do
        context "when value for whodunnit is a persisted ActiveRecord object" do
          it "returns the object" do
            # Note: A new instantiation of the object will be made. ActiveRecord makes equality on the id field.
            # TODO: Consider if this is wanted. At the minute, it will be a new instantiation each time it is called.
            version.whodunnit = persisted_admin
            version.save
            expect(version.actor).to eq(persisted_admin)
          end
        end

        context "when value for whodunnit is a new ActiveRecord object" do
          it "returns the string representation of the the object" do
            version.whodunnit = new_admin
            version.save
            expect(version.actor).to eq(new_admin.to_s)
          end
        end

        context "when value for whodunnit has a #to_global_id method and an id set" do
          it "returns the object" do
            # As we locate the object with ::GlobalID::Locator, it will be a different instantiation with it's own object_id.
            # TODO: Consider if this is wanted. At the minute, it will be a new instantiation each time it is called.
            version.whodunnit = brand_with_id
            version.save
            expect(version.actor).to be_a(Brand).and(have_attributes(
              id: "2", name: "Nestlay"
            ))
          end
        end

        context "when value for whodunnit has a #to_global_id but no id set" do
          it "returns the string representation of the object" do
            version.whodunnit = brand_without_id
            version.save
            expect(version.actor).to eq("Company name is a great brand")
          end
        end

        context "when value for whodunnit does not have a #to_global_id method" do
          it "returns the string representation of the value" do
            version.whodunnit = job
            version.save
            expect(version.actor).to eq("I am a job")
          end
        end

        context "when the value for whodunnit is a string" do
          it "returns the string" do
            version.whodunnit = "test"
            version.save
            expect(version.actor).to eq("test")
          end
        end
      end

      describe "#whodunnit" do
        context "when value for whodunnit is a persisted ActiveRecord object" do
          it "returns global id string for the object" do
            version.whodunnit = persisted_admin
            version.save
            expect(version.whodunnit).to eq(persisted_admin.to_gid.to_s)
          end
        end

        context "when value for whodunnit is a new ActiveRecord object" do
          it "returns the string representation of the the object" do
            version.whodunnit = new_admin
            version.save
            expect(version.whodunnit).to eq(new_admin.to_s)
          end
        end

        context "when value for whodunnit has a #to_global_id method and an id set" do
          it "returns the global id string for the object" do
            version.whodunnit = brand_with_id
            version.save
            expect(version.whodunnit).to eq "gid://App/Brand/2"
          end
        end

        context "when value for whodunnit has a #to_global_id but no id set" do
          it "returns the string representation of the object" do
            version.whodunnit = brand_without_id
            version.save
            expect(version.whodunnit).to eq("Company name is a great brand")
          end
        end

        context "when value for whodunnit does not have a #to_global_id method" do
          it "returns the string representation of the value" do
            version.whodunnit = job
            version.save
            expect(version.whodunnit).to eq("I am a job")
          end
        end

        context "when the value for whodunnit is a string" do
          it "returns the string" do
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
