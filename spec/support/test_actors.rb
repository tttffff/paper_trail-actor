RSpec.shared_context "test actors" do
  # A persisted ActiveRecord object that implements #to_global_id
  let(:persisted_admin) { Admin.create!(name: "Persisted admin") }

  # A new (unsaved) ActiveRecord object that implements #to_global_id
  let(:new_admin) { Admin.new(name: "New admin") }

  # A non-ActiveRecord object that implements #to_global_id with an id
  let(:brand_with_id) { Brand.find("2") }

  # A non-ActiveRecord object that implements #to_global_id but without an id
  let(:brand_without_id) { Brand.find(nil) }

  # An object that does not implement #to_global_id
  let(:job) { Job.new }
end
