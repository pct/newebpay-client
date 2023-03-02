require_relative 'lib/newebpay/version'

Gem::Specification.new do |spec|
  spec.name          = "newebpay-client"
  spec.version       = Newebpay::VERSION
  spec.authors       = ["Daniel Lin (pct)"]
  spec.email         = ["pct@4point-inc.com"]

  spec.summary       = %q{藍新金流 newebpay-client (開發中，勿用)}
  spec.description   = %q{藍新金流 newebpay-client (開發中，勿用)}
  spec.homepage      = "https://github.com/pct/newebpay-client"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.6.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/pct/newebpay-client"
  spec.metadata["changelog_uri"] = "https://github.com/pct/newebpay-client/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # 相依套件
  spec.add_runtime_dependency "activesupport", [">= 4.0"]
end
