# frozen_string_literal: true

lib = File.expand_path(%(lib), __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require_relative %(./lib/stitches/synthesizer/version)

Gem::Specification.new do |spec|
  spec.name                  = %(stitches-synthesizer)
  spec.version               = Stitches::Synthesizer::VERSION
  spec.authors               = [%(t3rro)]
  spec.email                 = [%()]
  spec.description           = %(create resource manifests)
  spec.summary               = %(create resource manifests)
  spec.homepage              = %(https://github.com/t3rro/#{spec.name})
  spec.license               = %(IPA)
  spec.files                 = `git ls-files`.split($OUTPUT_RECORD_SEPARATOR)
  spec.require_paths         = [%(lib)]
  spec.required_ruby_version = %(>= #{`cat .ruby-version`})

  #############################################################################
  # Dependencies
  #############################################################################

  %i[
    rubocop-rspec
    rubocop-rake
    solargraph
    keycutter
    rubocop
    rspec
    rake
    yard
  ].each do |gem|
    spec.add_development_dependency(gem)
  end

  spec.metadata[%(rubygems_mfa_required)] = %(true)
end
