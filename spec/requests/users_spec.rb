# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users' do
  let(:client_secret) { SecureRandom.uuid }
  let(:client) { create(:client, secret: client_secret) }

  describe 'POST /users' do
    context 'when successful' do
      let(:params) do
        {
          name: Faker::Name.name,
          email: Faker::Internet.unique.email,
          password: Faker::Internet.password
        }
      end

      before do
        post '/users', params: params.to_json, headers: {
          'Content-Type' => 'application/json',
          'Accept' => 'application/json',
          'Authorization' => "Basic #{Base64.encode64("#{client.id}:#{client_secret}")}"
        }
      end

      it 'allows clients to create users' do
        expect(response).to have_http_status(:created)
      end

      it 'returns the correct body' do
        expect(response.parsed_body.count).to eq(5)
        expect(response.parsed_body['id']).to match(/\b[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}\b/)
        expect(response.parsed_body['name']).to eq(params[:name])
        expect(response.parsed_body['email']).to eq(params[:email])
        expect(response.parsed_body['updated_at'].to_datetime.utc).to be_within(1.second).of Time.now.utc
        expect(response.parsed_body['created_at'].to_datetime.utc).to be_within(1.second).of Time.now.utc
      end

      it 'returns the correct headers' do
        expect(response.headers['X-Access-Token']).to match(/^[a-zA-Z0-9_-]+\.[a-zA-Z0-9_-]+\.[a-zA-Z0-9_-]+$/)
        expect(response.headers['X-Id-Token']).to match(/^[a-zA-Z0-9_-]+\.[a-zA-Z0-9_-]+\.[a-zA-Z0-9_-]+$/)
      end
    end

    context 'when unsuccessful' do
      let(:params) do
        {
          name: Faker::Name.name,
          email: Faker::Internet.unique.email,
          password: Faker::Internet.password
        }
      end

      context 'when authorization header is missing' do
        it 'does not allow a user to be created' do
          post '/users', params: params.to_json, headers: {
            'Content-Type' => 'application/json',
            'Accept' => 'application/json'
          }

          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'when authorization header is bad' do
        it 'does not allow a user to be created' do
          post '/users', params: params.to_json, headers: {
            'Content-Type' => 'application/json',
            'Accept' => 'application/json',
            'Authorization' => "Basic #{Base64.encode64("#{client.id}:bad")}"
          }

          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'when request body is missing required params' do
        context 'when name is missing' do
          it 'does not allow a user to be created' do
            params.delete(:name)

            post '/users', params: params.to_json, headers: {
              'Content-Type' => 'application/json',
              'Accept' => 'application/json',
              'Authorization' => "Basic #{Base64.encode64("#{client.id}:#{client_secret}")}"
            }

            expect(response).to have_http_status(:bad_request)

            expect(response.parsed_body['errors'].first).to eq('param is missing or the value is empty: name')
          end
        end

        context 'when email is missing' do
          it 'does not allow a user to be created' do
            params.delete(:email)

            post '/users', params: params.to_json, headers: {
              'Content-Type' => 'application/json',
              'Accept' => 'application/json',
              'Authorization' => "Basic #{Base64.encode64("#{client.id}:#{client_secret}")}"
            }

            expect(response).to have_http_status(:bad_request)

            expect(response.parsed_body['errors'].first).to eq('param is missing or the value is empty: email')
          end
        end

        context 'when password is missing' do
          it 'does not allow a user to be created' do
            params.delete(:password)

            post '/users', params: params.to_json, headers: {
              'Content-Type' => 'application/json',
              'Accept' => 'application/json',
              'Authorization' => "Basic #{Base64.encode64("#{client.id}:#{client_secret}")}"
            }

            expect(response).to have_http_status(:bad_request)

            expect(response.parsed_body['errors'].first).to eq('param is missing or the value is empty: password')
          end
        end
      end
    end
  end
end
