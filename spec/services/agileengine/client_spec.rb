# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Agileengine::Client do
  let(:client) { described_class.new }

  before do
    allow(client).to receive(:connection).and_return(connection)
  end

  describe '#images' do
    let(:connection) { double(get: double(status: 200, body: { images: [] }.to_json), headers: {}) }

    it 'returns images' do
      expect(client.images).to eq(images: [])
    end

    context 'with 401 status' do
      let(:connection) do
        double(get: double(status: 401, body: {}.to_json), headers: {}, post: double(body: {}.to_json))
      end

      it 'raises UnauthorizedError after 4 attempts to retry' do
        expect(client).to receive(:with_authentication).exactly(4).times.and_call_original
        expect { client.images }.to raise_error UnauthorizedError
      end
    end
  end

  describe '#image' do
    let(:connection) { double(get: double(status: 200, body: { id: 1 }.to_json), headers: {}) }

    it 'returns image' do
      expect(client.image(1)).to eq(id: 1)
    end

    context 'with 401 status' do
      let(:connection) do
        double(get: double(status: 401, body: {}.to_json), headers: {}, post: double(body: {}.to_json))
      end

      it 'raises UnauthorizedError after 4 attempts to retry' do
        expect(client).to receive(:with_authentication).exactly(4).times.and_call_original
        expect { client.image(1) }.to raise_error UnauthorizedError
      end
    end
  end
end
