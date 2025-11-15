# frozen_string_literal: true

require "spec_helper"
require_relative "../support/test_actors"

# These integration tests verify the gem works correctly in a real Rails application.
# While some functionality overlaps with unit tests, these provide confidence that
# the gem integrates properly with PaperTrail in realistic usage scenarios.

RSpec.describe "User for paper trail", type: :request do
  include_context "test actors"
  let(:order) { Order.create!(order_number: "Original order number") }
  let(:order_version_whodunnit) { order.versions.last.whodunnit } # To get the version for the update event.
  let(:product_version_whodunnit) { Product.last.versions.first.whodunnit } # To get the version for the create event.
  let(:admin) { Admin.create! }

  # To protect against false positives if we accidentally test against a version created by the spec.
  before { PaperTrail::Request.whodunnit = "Made by the spec!" }

  def update_order_number_with_request
    patch order_path(order), params: {order_number: "New order number"}
  end

  def update_order_number_with_public_request
    patch public_update_order_path(order), params: {order_number: "New order number"}
  end

  def update_order_number_with_other_request
    patch other_order_path(order), params: {order_number: "New order number"}
  end

  def create_product_with_request
    post products_path, params: {name: "Car Part", price_in_cents: "99999"}
  end

  def create_product_with_other_request
    post other_products_path, params: {name: "Car Part", price_in_cents: "99999"}
  end

  # When the current user is nil (not when it is not defined)
  context "when the current user is not set" do
    it "keeps whodunnit as nothing" do
      create_product_with_request
      expect(product_version_whodunnit).to be_blank
    end
  end

  context "when the current user is an object which implements #to_global_id and has an id set" do
    it "sets whodunnit to the global id of the object" do
      post sessions_path, params: {brand_id: 3}
      create_product_with_request
      expect(product_version_whodunnit).to eq("gid://test-audit-app/Brand/3")
    end
  end

  context "when the current user is an object which implements #to_global_id but doesn't have an id set" do
    it "sets whodunnit to the string representation of the object" do
      post sessions_path, params: {brand_id: ""}
      create_product_with_request
      expect(product_version_whodunnit).to eq("Company name is a great brand")
    end
  end

  context "when the current user is a string" do
    it "sets the whodunnit for the version as the string" do
      update_order_number_with_request
      expect(order_version_whodunnit).to eq("Public user")
    end
  end

  context "when the current user is a persisted active record object" do
    it "sets the whodunnit for the version as the global id of the object" do
      post sessions_path, params: {admin_id: admin.id}
      update_order_number_with_request
      expect(order_version_whodunnit).to eq("gid://test-audit-app/Admin/#{admin.id}")
    end
  end

  context "when the current user is a new active record object" do
    it "sets the whodunnit to the string representation of the object" do
      post sessions_path, params: {other_item: "new_admin"}
      create_product_with_other_request
      expect(product_version_whodunnit).to eq("I am an admin")
    end
  end

  context "when the current user is an object which doesn't implement #to_global_id" do
    it "sets the whodunnit to the string representation of the object" do
      post sessions_path, params: {other_item: "job"}
      create_product_with_other_request
      expect(product_version_whodunnit).to eq("I am a job")
    end
  end

  context "when the current user is not defined" do
    it "keeps whodunnit as nothing" do
      update_order_number_with_public_request
      expect(order_version_whodunnit).to be_blank
    end
  end

  context "when user for papertrail has been overwritted" do
    it "sets the whodunnit based on the overwritten value" do
      update_order_number_with_other_request
      expect(order_version_whodunnit).to eq("Other order controller")
    end
  end
end
