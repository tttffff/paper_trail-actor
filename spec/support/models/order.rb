require "paper_trail"
require "paper_trail-actor"

class Order < ActiveRecord::Base
  has_paper_trail
end
