module Api
    module V1
      class UrlsController < ApplicationController
        before_action :authenticate_api_token
  
        def create
          long_url = params[:long_url]
          short_url = SecureRandom.hex(4)
  
          url = Url.new(long_url: long_url, short_url: short_url)
          if url.save
            render json: { long_url: url.long_url, short_url: short_url }, status: :created
          else
            render json: { errors: url.errors.full_messages }, status: :unprocessable_entity
          end
        end
  
        private
  
        def authenticate_api_token
          token = request.headers['Authorization']
          render json: { error: 'Unauthorized' }, status: :unauthorized unless token == 'your_api_token'
        end
      end
    end
  end
  