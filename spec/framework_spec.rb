# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Framework do
  it 'has a version number' do
    expect(Framework::VERSION).not_to be nil
  end

  describe '.configure' do
    it 'yields configuration object' do
      expect { |b| Framework.configure(&b) }.to yield_with_args(Framework.config)
    end

    it 'sets configuration options' do
      Framework.configure do |config|
        config.environment = 'test'
      end

      expect(Framework.config.environment).to eq('test')
    end
  end

  describe '.routes' do
    it 'configures routes on router instance' do
      expect(Framework::Router.instance).to receive(:get).with('/', to: 'home#index')
      
      Framework.routes do
        get '/', to: 'home#index'
      end
    end
  end
end