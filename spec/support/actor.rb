require_relative "admin"

RSpec.shared_context "a project with a possible active record actor" do
  before { GlobalID.app = "App" } # Needs to be set to something for globalid to work

  let(:admin) { Admin.create(name: "admin") }
end
