require "globalid"

class Admin < ActiveRecord::Base
  # In a Rails project, GlobalID::Identification is automatically mixed into Active Record classes.
  include ::GlobalID::Identification
end
