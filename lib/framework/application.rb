# frozen_string_literal: true

module Framework
  class Application
    attr_reader :middleware_stack
    
    def initialize
      @middleware_stack = []
      setup_default_middleware
    end
    
    def call(env)
      # Build middleware stack and process request
      app = lambda { |env| route_request(env) }
      
      middleware_stack.reverse.each do |middleware|
        app = middleware.new(app)
      end
      
      app.call(env)
    end
    
    def use(middleware, *args, &block)
      middleware_stack << lambda { |app| middleware.new(app, *args, &block) }
    end
    
    private
    
    def setup_default_middleware
      # Add default middleware
      use Rack::ShowExceptions if development?
      use Rack::MethodOverride
      use Rack::Head
    end
    
    def route_request(env)
      request = Rack::Request.new(env)
      route = Framework::Router.instance.match(request.request_method, request.path_info)
      
      if route
        controller_action = route[:controller_action]
        controller_name, action_name = parse_controller_action(controller_action)
        
        controller_class = constantize_controller(controller_name)
        controller = controller_class.new(env, action_name)
        controller.call
      else
        not_found_response
      end
    rescue => e
      error_response(e)
    end
    
    def parse_controller_action(controller_action)
      parts = controller_action.split('#')
      [parts[0], parts[1]]
    end
    
    def constantize_controller(controller_name)
      # Convert 'users_controller' to 'UsersController'
      class_name = controller_name.split('_').map(&:capitalize).join
      Object.const_get(class_name)
    end
    
    def not_found_response
      [404, {'Content-Type' => 'text/plain'}, ['Not Found']]
    end
    
    def error_response(error)
      if development?
        [500, {'Content-Type' => 'text/plain'}, [error.message + "\n" + error.backtrace.join("\n")]]
      else
        [500, {'Content-Type' => 'text/plain'}, ['Internal Server Error']]
      end
    end
    
    def development?
      ENV['RACK_ENV'] == 'development'
    end
  end
end