RSpec.shared_context "a project with multiple possible actors" do
  let(:persisted_admin) { Admin.create!(name: "Persisted admin") }
  let(:new_admin) { Admin.new(name: "New admin") }
  let(:brand_with_id) { Brand.find("2") }
  let(:brand_without_id) { Brand.find(nil) }
  let(:job) { Job.new }
end
