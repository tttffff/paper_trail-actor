require_relative "test_actors"

RSpec.shared_examples "an attributor that accepts multiple attribution types" do
  include_context "test actors"

  describe "#actor" do
    context "when value for whodunnit is a persisted ActiveRecord object" do
      it "returns the object" do
        # Note: A new instantiation of the object will be made. ActiveRecord makes equality on the id field.
        # TODO: Consider if this is wanted. At the minute, it will be a new instantiation each time it is called.
        subject.whodunnit = persisted_admin
        expect(subject.actor).to eq(persisted_admin)
      end
    end

    context "when value for whodutnnit is a new ActiveRecord object" do
      it "returns the string representation of the the object" do
        subject.whodunnit = new_admin
        expect(subject.actor).to eq(new_admin.to_s)
      end
    end

    context "when value for whodunnit has a #to_global_id method and an id set" do
      it "returns the object" do
        # As we locate the object with ::GlobalID::Locator, it will be a different instantiation with it's own object_id.
        # TODO: Consider if this is wanted. At the minute, it will be a new instantiation each time it is called.
        subject.whodunnit = brand_with_id
        expect(subject.actor).to be_a(Brand)
          .and(have_attributes(id: "2", name: "Nestlay"))
      end
    end

    context "when value for whodunnit has a #to_global_id but no id set" do
      it "returns the string representation of the object" do
        subject.whodunnit = brand_without_id
        expect(subject.actor).to eq("Company name is a great brand")
      end
    end

    context "when value for whodunnit does not have a #to_global_id method" do
      it "returns the string representation of the value" do
        subject.whodunnit = job
        expect(subject.actor).to eq("I am a job")
      end
    end

    context "when the value for whodunnit is a string" do
      it "returns the string" do
        subject.whodunnit = "test"
        expect(subject.actor).to eq("test")
      end
    end
  end

  describe "#whodunnit" do
    context "when value for whodunnit is a persisted ActiveRecord object" do
      it "returns global id string for the object" do
        subject.whodunnit = persisted_admin
        expect(subject.whodunnit).to eq("gid://test-audit-app/Admin/#{persisted_admin.id}")
      end
    end

    context "when value for whodunnit is a new ActiveRecord object" do
      it "returns the string representation of the the object" do
        subject.whodunnit = new_admin
        expect(subject.whodunnit).to eq(new_admin.to_s)
      end
    end

    context "when value for whodunnit has a #to_global_id method and an id set" do
      it "returns the global id string for the object" do
        subject.whodunnit = brand_with_id
        expect(subject.whodunnit).to eq("gid://test-audit-app/Brand/2")
      end
    end

    context "when value for whodunnit has a #to_global_id but no id set" do
      it "returns the string representation of the object" do
        subject.whodunnit = brand_without_id
        expect(subject.whodunnit).to eq("Company name is a great brand")
      end
    end

    context "when value for whodunnit does not have a #to_global_id method" do
      it "returns the string representation of the value" do
        subject.whodunnit = job
        expect(subject.whodunnit).to eq("I am a job")
      end
    end

    context "when the value for whodunnit is a string" do
      it "returns the string" do
        subject.whodunnit = "test"
        expect(subject.whodunnit).to eq("test")
      end
    end
  end
end
