require "spec_helper"
require_relative "../support/actor"

module PaperTrailActor
  RSpec.describe Request do
    include_context "a project with a possible active record actor"

    describe ".actor" do
      context "when value for whodunnit is object of ActiveRecord" do
        it "returns object" do
          PaperTrail.request.whodunnit = admin
          expect(PaperTrail.request.actor).to eq(admin)
        end
      end

      context "when value for whodunnit is not an object of ActiveRecord" do
        it "returns value itself" do
          PaperTrail.request.whodunnit = "test"
          expect(PaperTrail.request.actor).to eq("test")
        end
      end
    end

    describe ".whodunit" do
      context "when value for whodunnit is object of ActiveRecord" do
        it "returns global id" do
          PaperTrail.request.whodunnit = admin
          expect(PaperTrail.request.whodunnit).to eq(admin.to_gid)
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
