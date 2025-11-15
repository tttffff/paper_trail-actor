require "spec_helper"
require_relative "../support/attributor_examples"

module PaperTrailActor
  RSpec.describe VersionConcern do
    include_context "test actors"

    context "when using the built in paper_trail version class" do
      let(:order) { Order.create!(order_number: "ord_1", total: 100) }
      subject { order.versions.last }

      it_behaves_like "an attributor that accepts multiple attribution types"
    end

    context "when using a custom version class" do
      let(:product) { Product.create!(name: "Coffee cup", price_in_cents: 1500) }
      subject { product.versions.last }

      it_behaves_like "an attributor that accepts multiple attribution types"
    end
  end
end
