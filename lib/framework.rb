# frozen_string_literal: true

require_relative 'framework/version'
require_relative 'framework/base'
require_relative 'framework/routing'
require_relative 'framework/controller'
require_relative 'framework/application'

module Framework
  class Error < StandardError; end
  
  # Configuration management
  class << self
    attr_accessor :config
    
    def configure
      self.config ||= Configuration.new
      yield(config) if block_given?
    end
    
    def routes(&block)
      Router.instance.instance_eval(&block)
    end
  end
  
  class Configuration
    attr_accessor :environment, :logger, :middleware_stack
    
    def initialize
      @environment = ENV.fetch('RACK_ENV', 'development')
      @logger = Logger.new($stdout)
      @middleware_stack = []
    end
  end
end