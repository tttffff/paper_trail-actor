require "spec_helper"
require_relative "../support/actors"

module PaperTrailActor
  RSpec.describe Request do
    include_context "a project with multiple possible actors"

    describe ".actor" do
      context "when value for whodunnit is a persisted ActiveRecord object" do
        it "returns the object" do
          # Note: A new instantiation of the object will be made. ActiveRecord makes equality on the id field.
          # TODO: Consider if this is wanted. At the minute, it will be a new instantiation each time it is called.
          PaperTrail.request.whodunnit = persisted_admin
          expect(PaperTrail.request.actor).to eq(persisted_admin)
        end
      end

      context "when value for whodunnit is a new ActiveRecord object" do
        it "returns the string representation of the the object" do
          PaperTrail.request.whodunnit = new_admin
          expect(PaperTrail.request.actor).to eq(new_admin.to_s)
        end
      end

      context "when value for whodunnit has a #to_global_id method and an id set" do
        it "returns the object" do
          # As we locate the object with ::GlobalID::Locator, it will be a different instantiation with it's own object_id.
          # TODO: Consider if this is wanted. At the minute, it will be a new instantiation each time it is called.
          PaperTrail.request.whodunnit = brand_with_id
          expect(PaperTrail.request.actor).to be_a(Brand).and(have_attributes(
            id: "2", name: "Nestlay"
          ))
        end
      end

      context "when value for whodunnit has a #to_global_id but no id set" do
        it "returns the string representation of the object" do
          PaperTrail.request.whodunnit = brand_without_id
          expect(PaperTrail.request.actor).to eq("Company name is a great brand")
        end
      end

      context "when value for whodunnit does not have a #to_global_id method" do
        it "returns the string representation of the object" do
          PaperTrail.request.whodunnit = job
          expect(PaperTrail.request.actor).to eq("I am a job")
        end
      end

      context "when the value for whodunnit is a string" do
        it "returns the string" do
          PaperTrail.request.whodunnit = "test"
          expect(PaperTrail.request.actor).to eq("test")
        end
      end
    end

    describe ".whodunit" do
      context "when value for whodunnit is a persisted ActiveRecord object" do
        it "returns the global id" do
          PaperTrail.request.whodunnit = persisted_admin
          expect(PaperTrail.request.whodunnit).to eq(persisted_admin.to_global_id.to_s)
        end
      end

      context "when value for whodunnit is a new ActiveRecord object" do
        it "returns the string representation of the the object" do
          PaperTrail.request.whodunnit = new_admin
          expect(PaperTrail.request.whodunnit).to eq(new_admin.to_s)
        end
      end

      context "when value for whodunnit has a #to_global_id method and an id set" do
        it "returns the global id" do
          PaperTrail.request.whodunnit = brand_with_id
          expect(PaperTrail.request.whodunnit).to eq("gid://test-audit-app/Brand/2")
        end
      end

      context "when value for whodunnit has a #to_global_id but no id set" do
        it "returns the string representation of the object" do
          PaperTrail.request.whodunnit = brand_without_id
          expect(PaperTrail.request.whodunnit).to eq("Company name is a great brand")
        end
      end

      context "when value for whodunnit does not have a #to_global_id method" do
        it "returns the string representation of the value" do
          PaperTrail.request.whodunnit = job
          expect(PaperTrail.request.whodunnit).to eq("I am a job")
        end
      end

      context "when the value for whodunnit is a string" do
        it "returns the string" do
          PaperTrail.request.whodunnit = "test"
          expect(PaperTrail.request.whodunnit).to eq("test")
        end
      end
    end
  end
end
