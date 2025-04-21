require_relative "actor_mixin"

module PaperTrailActor
  module Request
    include ActorMixin

    def whodunnit=(input_value)
      super(global_id_string_or_fallback(input_value))
    end
  end
end
