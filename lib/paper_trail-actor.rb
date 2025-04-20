require "paper_trail-actor/version"
require "paper_trail-actor/request"
require "paper_trail-actor/version_concern"

module ::PaperTrail
  module Request
    class << self
      prepend ::PaperTrailActor::Request
    end
  end
end

module ::PaperTrail
  module VersionConcern
    include ::PaperTrailActor::VersionConcern
  end
end
