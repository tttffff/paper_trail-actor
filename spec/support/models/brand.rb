require "globalid"

# A possible actor in the spec system.
# For example, a background job is ran for each brand which modifies an order.

class Brand
  include ::GlobalID::Identification

  BRANDS = {
    "1" => "Coca-Coola",
    "2" => "Nestlay",
    "3" => "Heins"
  }

  def self.find(id)
    name = BRANDS[id] || "Company name"
    new(id, name)
  end

  attr_reader :id, :name

  def initialize(id, name)
    @id, @name = id, name
  end

  def to_s
    "#{name} is a great brand"
  end
end
