# frozen_string_literal: true

require_relative 'base'

module Framework
  class Controller < Base
    include Rack::Utils
    
    attr_reader :action_name, :params
    
    def initialize(env, action_name = nil)
      super(env)
      @action_name = action_name
      @params = extract_params
    end
    
    def call
      if respond_to?(action_name)
        send(action_name)
      else
        not_found
      end
    end
    
    protected
    
    def render(template_name = nil, locals = {})
      template_name ||= action_name
      template_path = "views/#{controller_name}/#{template_name}.html.erb"
      
      if File.exist?(template_path)
        template_content = File.read(template_path)
        rendered = ERB.new(template_content).result(binding)
        response.write(rendered)
      else
        response.write("Template not found: #{template_path}")
      end
      
      response.finish
    end
    
    def render_json(object)
      require 'json'
      response['Content-Type'] = 'application/json'
      response.write(object.to_json)
      response.finish
    end
    
    def redirect_to(path, status = 302)
      response.redirect(path, status)
      response.finish
    end
    
    def not_found
      response.status = 404
      response.write('Not Found')
      response.finish
    end
    
    def controller_name
      self.class.name.downcase.gsub('controller', '').gsub('::', '/')
    end
    
    private
    
    def extract_params
      # Merge query params and POST params
      query_params = request.GET
      post_params = request.POST || {}
      path_params = extract_path_params
      
      query_params.merge(post_params).merge(path_params)
    end
    
    def extract_path_params
      # Extract parameters from URL path (e.g., /users/:id)
      # This would be set by the routing system
      @path_params || {}
    end
    
    def set_path_params(params)
      @path_params = params
    end
  end
end