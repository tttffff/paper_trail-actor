require "spec_helper"

module PaperTrailActor
  RSpec.describe "Version" do
    it "is a valid gem version" do
      expect { Gem::Version.new(PaperTrailActor::VERSION) }.not_to raise_error
    end

    it "has a number for the major, minor, and patch" do
      parts = PaperTrailActor::VERSION.split(".")
      expect(parts.size).to eq 3
      expect { parts.map { |part| Integer(part) } }.not_to raise_error
    end
  end
end
