# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new

desc 'Run all tests and linting'
task test: [:spec, :rubocop]

desc 'Generate documentation with YARD'
task :docs do
  sh 'yard doc'
end

desc 'Start development server'
task :server do
  sh 'rerun -- rackup examples/config.ru'
end

task default: :test