require_relative "actor_mixin"

module PaperTrailActor
  module VersionConcern
    include ActorMixin

    def whodunnit=(input_value)
      whodunnit_value = global_id_string_or_fallback(input_value)
      _write_attribute("whodunnit", whodunnit_value)
    end
  end
end
