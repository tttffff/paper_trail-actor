require "paper_trail-actor/version"
require "paper_trail-actor/request"
require "paper_trail-actor/version_concern"
require "paper_trail-actor/rails/controller"

module ::PaperTrail
  module Request
    class << self
      prepend ::PaperTrailActor::Request
    end
  end

  module VersionConcern
    include ::PaperTrailActor::VersionConcern
  end

  module Rails
    module Controller
      prepend ::PaperTrailActor::Rails::Controller
    end
  end
end
