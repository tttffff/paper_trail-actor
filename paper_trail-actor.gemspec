lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "paper_trail-actor/version"

Gem::Specification.new do |spec|
  spec.name = "paper_trail-actor"
  spec.version = PaperTrailActor::VERSION
  spec.authors = ["tttffff"]
  spec.email = ["tristanfellows@icloud.com"]
  spec.summary = "An extension to PaperTrail. Using this gem, you can fetch the ActiveRecord object that was responsible for changes"
  spec.description = spec.summary
  spec.homepage = "https://github.com/tttffff/paper_trail-actor"
  spec.license = "MIT"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage + "/blob/main/CHANGELOG.md"

  gemspec = File.basename(__FILE__)
  ignore_files_starting_with = %w[spec/ .git .github Gemfile] << gemspec
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      f.start_with?(*ignore_files_starting_with)
    end
  end
  spec.executables = []
  spec.require_paths = ["lib"]

  spec.add_dependency "paper_trail", ">= 11.0.0"
  spec.add_dependency "globalid" # Also a dependency of standard rails gems.

  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "standard"
end
