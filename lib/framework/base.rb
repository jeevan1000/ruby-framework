# frozen_string_literal: true

require 'rack'
require 'logger'

module Framework
  class Base
    attr_reader :env, :request, :response
    
    def initialize(env)
      @env = env
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end
    
    def call
      # Override in subclasses
      response.write('Hello from Framework!')
      response.finish
    end
    
    protected
    
    def params
      request.params
    end
    
    def headers
      request.env.select { |k, v| k.start_with?('HTTP_') }
    end
    
    def method
      request.request_method
    end
    
    def path
      request.path_info
    end
  end
end