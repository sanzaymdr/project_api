# frozen_string_literal: true

module Api
  module V1
    # Controller to handle user creation and user sign in
    class UsersController < ApiController
      # REGISTER
      def sign_up
        user = User.create!(sign_up_params)
        if user.valid?
          token = encode_token({ user_id: user.id })
          render json: { user:, token: }
        end
      rescue ActiveRecord::RecordInvalid => e
        render json: { error: e.message }
      end

      # LOGGING IN
      def sign_in
        user = User.find_by(email: sign_in_params[:email])
        if user&.authenticate(sign_in_params[:password])
          token = encode_token({ user_id: user.id })
          render json: { token: }
        else
          render json: { error: 'Invalid email or password' }
        end
      end

      private

      def sign_in_params
        params.require(:auth).permit(:email, :password)
      end

      def sign_up_params
        params.permit(:first_name, :last_name, :email, :password, :country)
      end
    end
  end
end
