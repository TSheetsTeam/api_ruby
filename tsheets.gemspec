# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tsheets/version'

Gem::Specification.new do |spec|
  spec.name          = "tsheets"
  spec.version       = Tsheets::VERSION
  spec.authors       = ["Kamil Ciemniewski"]
  spec.email         = ["kamil@endpoint.com"]

  spec.summary       = %q{API library helper for TSheets.com}
  spec.description   = %q{Allows to use the TSheets.com API to manage the timesheets and all other related data}
  spec.homepage      = "http://tsheets.com"
  spec.license       = "MIT"

  spec.files         = Dir['{lib}/**/*', 'README*', 'tsheets*', 'Gemfile', 'LICENSE*', 'Rakefile*']
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "typhoeus", "~> 0.7.2"
  spec.add_runtime_dependency "backports"

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 12.3", ">= 12.3.3" # 12.3.3 fixes CVE-2020-8130
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-mocks"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rb-fsevent"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "terminal-notifier"
  spec.add_development_dependency "terminal-notifier-guard"
  spec.add_development_dependency "colorize"
end
