require "paper_trail"
require "paper_trail-globalid"

# See https://github.com/paper-trail-gem/paper_trail#6a-custom-version-classes

class ApplicationVersion < ActiveRecord::Base
  include PaperTrail::VersionConcern
  self.abstract_class = true
end

class ProductVersion < ApplicationVersion
  self.table_name = :product_versions
end

class Product < ActiveRecord::Base
  has_paper_trail versions: {class_name: "ProductVersion"}
end
