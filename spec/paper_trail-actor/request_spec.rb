require "spec_helper"
require_relative "../support/attributor_examples"

module PaperTrailActor
  RSpec.describe Request do
    subject { PaperTrail.request }

    it_behaves_like "an attributor that accepts multiple attribution types"
  end
end
