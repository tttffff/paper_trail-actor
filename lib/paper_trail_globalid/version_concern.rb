module PaperTrailGlobalid
  module VersionConcern
    def whodunnit=(input_value)
      whodunnit_value = if input_value.is_a?(ActiveRecord::Base)
        input_value.to_gid
      else
        input_value
      end
      _write_attribute("whodunnit", whodunnit_value)
    end

    # Returns an object which was responsible for a change
    # you need to store global_id to whodunnit field to make this method return the object(who was responsible)
    # for example, whodunnit => "gid://app/Order/1" then
    # whodunnit_user will return Order.find_by(id: 1) in application scope.
    def actor
      ::GlobalID::Locator.locate(whodunnit) || whodunnit
    end
  end
end
