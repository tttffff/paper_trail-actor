ENV["RAILS_ENV"] ||= "test"

require "byebug"
require "active_record/railtie"
require "globalid"
require "paper_trail"
require "paper_trail-actor"
require "rspec/rails"

require_relative "support/test_audit_app/config/setup"
require_relative "support/test_audit_app/db/migrate"

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.filter_run_when_matching :focus
  config.example_status_persistence_file_path = "spec/examples.txt"
  config.disable_monkey_patching!
  config.warnings = true
  config.default_formatter = "doc" if config.files_to_run.one?
  config.profile_examples = 3
  config.order = :random
  Kernel.srand config.seed
end
