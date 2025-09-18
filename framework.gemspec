# frozen_string_literal: true

require_relative 'lib/framework/version'

Gem::Specification.new do |spec|
  spec.name = 'ruby-framework'
  spec.version = Framework::VERSION
  spec.authors = ['Framework Developer']
  spec.email = ['developer@framework.com']

  spec.summary = 'A lightweight Ruby web framework'
  spec.description = 'A Rack-based web framework for Ruby applications with MVC architecture'
  spec.homepage = 'https://github.com/jeevan1000/ruby-framework'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.0.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Runtime dependencies
  spec.add_dependency 'rack', '~> 3.0'
  spec.add_dependency 'json', '~> 2.6'

  # Development dependencies
  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.12'
  spec.add_development_dependency 'rubocop', '~> 1.50'
  spec.add_development_dependency 'yard', '~> 0.9'
end