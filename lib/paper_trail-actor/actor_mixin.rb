module PaperTrailActor
  module ActorMixin
    # Used for #whodunnit= methods
    def global_id_string_or_fallback(input_value)
      if input_value.respond_to?(:to_global_id) && input_value.id
        input_value.to_global_id.to_s
      else
        input_value.to_s
      end
    end

    def actor
      ::GlobalID::Locator.locate(whodunnit) || whodunnit
    end
  end
end
