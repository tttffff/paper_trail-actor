require "globalid"

# A possible actor in the spec system.
# For example, an admin is logged into a website and makes a change to an order.

class Admin < ActiveRecord::Base
  # In a Rails project, GlobalID::Identification is automatically mixed into Active Record classes.
  include ::GlobalID::Identification
end
