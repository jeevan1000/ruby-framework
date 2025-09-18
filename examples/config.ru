# Ruby Framework Example Application

require_relative '../lib/framework'

# Sample controller
class UsersController < Framework::Controller
  def index
    users = [
      { id: 1, name: 'John Doe', email: 'john@example.com' },
      { id: 2, name: 'Jane Smith', email: 'jane@example.com' }
    ]
    render_json(users)
  end
  
  def show
    user_id = params['id']
    user = { id: user_id.to_i, name: 'Sample User', email: 'user@example.com' }
    render_json(user)
  end
  
  def create
    # In a real app, this would save to database
    user = {
      id: rand(1000),
      name: params['name'],
      email: params['email']
    }
    render_json(user)
  end
end

class HomeController < Framework::Controller
  def index
    response.write('Welcome to Ruby Framework!')
    response.finish
  end
end

# Configure routes
Framework.routes do
  get '/', to: 'home#index'
  resources :users
end

# Run the application
run Framework::Application.new