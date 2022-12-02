# frozen_string_literal: true

module Api
  module V1
    # Controller to handle projects
    class ProjectsController < ApiController
      before_action :authorized, except: %i[show index]

      def index
        render json: Project.all
      end

      def show
        project = Project.find_by(id: project_params[:id])
        return render json: project, status: :ok if project

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
        if valid_user?(retrieve_project)
          retrieve_project.update!(project_params)
          render json: retrieve_project
        else
          render json: { error: 'Something went wrong. Please contact support' }, status: :unprocessable_entity
        end
      end

      def destroy
        if valid_user?(retrieve_project)
          retrieve_project.destroy!
          render json: { message: 'Deleted' }
        else
          render json: { error: 'Something went wrong. Please contact support' }, status: :unprocessable_entity
        end
      end

      private

      def valid_user?(project)
        project&.user == logged_in_user
      end

      def project_params
        params.permit(:id, :title, :description, :project_type, :location, :thumbnail)
      end

      def retrieve_project
        @retrieve_project ||= Project.find_by(id: project_params[:id])
      end
    end
  end
end
