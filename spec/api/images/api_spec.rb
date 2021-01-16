# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Images::API do
  include Rack::Test::Methods

  def app
    Images::API
  end

  describe '/search/{term}' do
    let(:images) { [{ camera: :testing }, { camera: :camera }].to_json }

    before do
      allow(Redis).to receive(:current).and_return(double(get: images))
      get '/search/test'
    end

    it 'returns images' do
      expect(JSON.parse(last_response.body)).to be_one
    end

    it 'returns ok' do
      expect(last_response.status).to eq 200
    end

    context 'when images are not present' do
      let(:images) {}

      it 'returns empty array' do
        expect(JSON.parse(last_response.body)).to be_empty
      end
    end
  end
end
