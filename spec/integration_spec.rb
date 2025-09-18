# frozen_string_literal: true

require 'spec_helper'

# Load the example application for integration testing
require_relative '../examples/config.ru'

RSpec.describe 'Framework Integration' do
  def app
    Rack::Builder.parse_file('examples/config.ru').first
  end

  describe 'GET /' do
    it 'returns welcome message' do
      get '/'
      expect(last_response).to be_ok
      expect(last_response.body).to include('Welcome to Ruby Framework!')
    end
  end

  describe 'GET /users' do
    it 'returns JSON list of users' do
      get '/users'
      expect(last_response).to be_ok
      expect(last_response.content_type).to include('application/json')
      
      json_response = JSON.parse(last_response.body)
      expect(json_response).to be_an(Array)
      expect(json_response.length).to eq(2)
      expect(json_response.first).to include('id', 'name', 'email')
    end
  end

  describe 'GET /users/:id' do
    it 'returns specific user' do
      get '/users/123'
      expect(last_response).to be_ok
      expect(last_response.content_type).to include('application/json')
      
      json_response = JSON.parse(last_response.body)
      expect(json_response['id']).to eq(123)
      expect(json_response).to include('name', 'email')
    end
  end

  describe 'POST /users' do
    it 'creates new user' do
      post '/users', { name: 'Test User', email: 'test@example.com' }
      expect(last_response).to be_ok
      expect(last_response.content_type).to include('application/json')
      
      json_response = JSON.parse(last_response.body)
      expect(json_response['name']).to eq('Test User')
      expect(json_response['email']).to eq('test@example.com')
      expect(json_response).to include('id')
    end
  end

  describe 'undefined routes' do
    it 'returns 404 for unknown paths' do
      get '/unknown'
      expect(last_response.status).to eq(404)
    end
  end
end