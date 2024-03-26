# frozen_string_literal: true

require_relative "lib/ollamachat/version"

Gem::Specification.new do |spec|
  spec.name = "ollamachat"
  spec.version = Ollamachat::VERSION
  spec.authors = ["kojix2"]
  spec.email = ["2xijok@gmail.com"]

  spec.summary = "ollamachat"
  spec.description = "ollamachat"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.files = Dir["*.{md,txt}", "{lib,exe}/**/*"]
  spec.bindir = "exe"
  spec.executable = "ollamachat"
  spec.require_paths = ["lib"]

  spec.add_dependency "ollama-ai"
  spec.add_dependency "glimmer-dsl-libui"
end
