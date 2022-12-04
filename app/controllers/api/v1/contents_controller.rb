# frozen_string_literal: true

module Api
  module V1
    # Controller to handle project's content
    class ContentsController < ApiController
      before_action :authorized, :valid_user?, except: %i[index show]

      def index
        content = Project.find_by(id: content_params[:project_id])&.contents
        return render json: content, status: :ok if content

        render json: { error: 'Record not found.' }, status: :not_found
      end

      def show
        content = Content.find_by(content_params)
        return render json: content, status: :ok if content

        render json: { error: 'Record not found.' }, status: :not_found
      end

      def create
        content = Content.create!(content_params)
        render json: content, status: :created
      rescue StandardError => e
        render json: { error: e.message }, status: :unprocessable_entity
      end

      def update
        retrieve_content.update!(content_params)
        render json: retrieve_content
      end

      def destroy
        retrieve_content.destroy!
        render json: { message: 'Deleted' }
      end

      private

      def retrieve_project
        Project.find_by(id: content_params[:project_id])
      end

      def retrieve_content
        @retrieve_content ||= Content.find_by(id: content_params[:id])
      end

      def valid_user?
        user = retrieve_content&.associated_user
        error_message = 'Something went wrong. Please contact support'
        status = :unprocessable_entity

        if user.nil?
          user = retrieve_project&.user
          error_message = 'You are not authorized to perform this action.'
          status = :unauthorized
        end

        return if user == logged_in_user

        render json: { error: error_message }, status:
      end

      def content_params
        params.permit(:title, :body, :project_id, :id)
      end
    end
  end
end
