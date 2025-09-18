# frozen_string_literal: true

require 'singleton'

module Framework
  class Router
    include Singleton
    
    attr_reader :routes
    
    def initialize
      @routes = []
    end
    
    def get(path, options = {})
      add_route('GET', path, options)
    end
    
    def post(path, options = {})
      add_route('POST', path, options)
    end
    
    def put(path, options = {})
      add_route('PUT', path, options)
    end
    
    def delete(path, options = {})
      add_route('DELETE', path, options)
    end
    
    def resources(name, options = {})
      # RESTful routes generator
      base_path = "/#{name}"
      controller = options[:controller] || "#{name}_controller"
      
      get "#{base_path}", to: "#{controller}#index"
      get "#{base_path}/new", to: "#{controller}#new"
      post "#{base_path}", to: "#{controller}#create"
      get "#{base_path}/:id", to: "#{controller}#show"
      get "#{base_path}/:id/edit", to: "#{controller}#edit"
      put "#{base_path}/:id", to: "#{controller}#update"
      delete "#{base_path}/:id", to: "#{controller}#destroy"
    end
    
    def match(method, path)
      routes.find do |route|
        route[:method] == method && path_matches?(route[:path], path)
      end
    end
    
    private
    
    def add_route(method, path, options)
      controller_action = options[:to]
      routes << {
        method: method,
        path: path,
        controller_action: controller_action,
        options: options
      }
    end
    
    def path_matches?(route_path, request_path)
      # Simple pattern matching - can be enhanced with regex
      route_segments = route_path.split('/')
      request_segments = request_path.split('/')
      
      return false if route_segments.length != request_segments.length
      
      route_segments.zip(request_segments).all? do |route_seg, request_seg|
        route_seg.start_with?(':') || route_seg == request_seg
      end
    end
  end
end