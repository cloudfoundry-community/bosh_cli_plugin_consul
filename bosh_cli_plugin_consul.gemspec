# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bosh_cli_plugin_consul/version'

Gem::Specification.new do |spec|
  spec.name          = "bosh_cli_plugin_consul"
  spec.version       = BoshCliPluginConsul::VERSION
  spec.authors       = ["Dr Nic Williams"]
  spec.email         = ["drnicwilliams@gmail.com"]
  spec.summary       = %q{BOSH CLI plugin for access, visibility and status of deployments using Consul}
  spec.description   = %q{BOSH CLI plugin for access, visibility and status of deployments using Consul}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "bosh_cli"
  spec.add_dependency "rest-client"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-fire"
end
