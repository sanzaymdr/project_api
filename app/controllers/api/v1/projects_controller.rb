# frozen_string_literal: true

module Api
  module V1
    # Controller to handle projects
    class ProjectsController < ApiController
      before_action :authorized, except: %i[show index]
      before_action :valid_user?, only: %i[update destroy]

      def index
        render json: Project.all
      end

      def show
        return render json: retrieve_project, status: :ok if retrieve_project

        render json: { error: 'Record not found.' }, status: :not_found
      end

      def create
        project = Project.create!(project_params.merge(user: logged_in_user))
        render json: project, status: :created
      rescue ActiveRecord::RecordInvalid => e
        render json: { error: e.message }, status: :unprocessable_entity
      end

      def user_projects
        associated_projects = logged_in_user&.projects
        render json: associated_projects, each_serializer: ProjectSerializer, exclude_owner: true
      end

      def update
        retrieve_project.update!(project_params)
        render json: retrieve_project
      end

      def destroy
        retrieve_project.destroy!
        render json: { message: 'Deleted' }
      end

      private

      def project_params
        params.permit(:id, :title, :description, :project_type, :location, :thumbnail)
      end

      def retrieve_project
        @retrieve_project ||= Project.find_by(id: project_params[:id])
      end

      def valid_user?
        return if retrieve_project&.user == logged_in_user

        render json: { error: 'Something went wrong. Please contact support' }, status: :unprocessable_entity
      end
    end
  end
end
