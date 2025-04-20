require "paper_trail_globalid/version"
require "paper_trail_globalid/request"
require "paper_trail_globalid/version_concern"

module ::PaperTrail
  module Request
    class << self
      prepend ::PaperTrailGlobalid::Request
    end
  end
end

module ::PaperTrail
  module VersionConcern
    include ::PaperTrailGlobalid::VersionConcern
  end
end
