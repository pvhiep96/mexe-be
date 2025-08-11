module Api
  module V1
    module Users
      class SessionsController < Devise::SessionsController
        respond_to :json

        private

        def respond_with(resource, _opts = {})
          render json: UserSerializer.new(resource), status: :ok
        end

        def respond_to_on_destroy
          render json: { message: 'Logged out successfully' }, status: :ok
        end
      end
    end
  end
end
