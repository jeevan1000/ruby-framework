# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Framework::Router do
  let(:router) { described_class.instance }

  before do
    router.instance_variable_set(:@routes, [])
  end

  describe '#get' do
    it 'adds GET route' do
      router.get('/users', to: 'users#index')
      
      expect(router.routes).to include(
        method: 'GET',
        path: '/users',
        controller_action: 'users#index',
        options: { to: 'users#index' }
      )
    end
  end

  describe '#resources' do
    it 'generates RESTful routes' do
      router.resources(:users)
      
      routes = router.routes
      expect(routes.size).to eq(7)
      
      # Check index route
      expect(routes).to include(
        method: 'GET',
        path: '/users',
        controller_action: 'users_controller#index',
        options: { to: 'users_controller#index' }
      )
      
      # Check show route
      expect(routes).to include(
        method: 'GET',
        path: '/users/:id',
        controller_action: 'users_controller#show',
        options: { to: 'users_controller#show' }
      )
    end
  end

  describe '#match' do
    before do
      router.get('/users', to: 'users#index')
      router.get('/users/:id', to: 'users#show')
    end

    it 'finds exact path match' do
      route = router.match('GET', '/users')
      expect(route[:controller_action]).to eq('users#index')
    end

    it 'finds parameterized path match' do
      route = router.match('GET', '/users/123')
      expect(route[:controller_action]).to eq('users#show')
    end

    it 'returns nil for no match' do
      route = router.match('GET', '/posts')
      expect(route).to be_nil
    end
  end
end