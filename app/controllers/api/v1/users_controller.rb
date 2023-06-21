# frozen_string_literal: true

module Api
  module V1
    # Controller to handle user creation and user sign in
    class UsersController < ApiController
      # REGISTER
      def sign_up
        user = User.create!(sign_up_params)
        render json: user, status: :created if user.valid?
      rescue ActiveRecord::RecordInvalid => e
        render json: { error: e.message }, status: :unprocessable_entity
      end

      # LOGGING IN
      def sign_in
        user = User.find_by(email: sign_in_params[:email])
        if user&.authenticate(sign_in_params[:password])
          render json: user, status: :created
        else
          render json: { error: 'Invalid email or password' }, status: :unprocessable_entity
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
