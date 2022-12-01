# frozen_string_literal: true

module Api
  module V1
    # Controller to handle project's content
    class ContentsController < ApiController
      before_action :authorized, except: %i[index show]

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
        if valid_user?(retrieve_project)
          content = Content.create!(content_params)
          render json: content, status: :ok
        else
          render json: { error: 'You are not authorized to create content.' }
        end
      rescue StandardError => e
        render json: { error: e.message }, status: :unprocessable_entity
      end

      def update
        if valid_user?(retrieve_project_content&.project)
          retrieve_project_content.update!(content_params)
          render json: { message: 'Content Updated' }
        else
          render json: { error: 'You are not authorized to update.' }, status: :unauthorized
        end
      end

      def destroy
        if valid_user?(retrieve_project_content&.project)
          retrieve_project_content.destroy!
          render json: { message: 'Content deleted.' }
        else
          render json: { error: 'You are not authorized to delete' }, status: :unauthorized
        end
      end

      private

      def retrieve_project
        Project.find_by(id: content_params[:project_id])
      end

      def retrieve_project_content
        @retrieve_project_content ||= Content.find_by(id: params[:id])
      end

      def valid_user?(project)
        project&.user == logged_in_user
      end

      def content_params
        params.permit(:title, :body, :project_id, :id)
      end
    end
  end
end
