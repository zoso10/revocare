# frozen_string_literal: true

require_relative "lib/revocare/version"

Gem::Specification.new do |spec|
  spec.name = "revocare"
  spec.version = Revocare::VERSION
  spec.authors = ["Tyler Ewing"]
  spec.email = ["tewing10@gmail.com"]
  spec.summary = "A simple gem for visualizing ActiveRecord callback chains"
  spec.description = "A simple gem for visualizing ActiveRecord callback chains"
  spec.homepage = "https://github.com/zoso10/revocare"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage + "/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
