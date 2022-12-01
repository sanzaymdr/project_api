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
        project = Project.where(id: params[:id])
        return render json: serialized_project(project).first, status: :ok if project.any?

        render json: { error: 'Record not found.' }, status: :not_found
      end

      def create
        project = Project.create!(project_params.merge(user: logged_in_user))
        render json: project
      end

      def user_projects
        associated_projects = serialized_project(logged_in_user&.projects)
        render json: associated_projects
      end

      def update
        if authorized_user?(retrieve_project)
          retrieve_project.update!(project_params)
          render json: { message: 'Project Updated' }
        else
          render json: { error: 'You are not authorized to update.' }, status: :unauthorized
        end
      end

      def destroy
        if authorized_user?(retrieve_project)
          retrieve_project.destroy!
          render json: { message: 'Project deleted.' }
        else
          render json: { error: 'You are not authorized to delete' }, status: :unauthorized
        end
      end

      private

      def authorized_user?(project)
        project&.user == logged_in_user
      end

      def project_params
        params.permit(:title, :description, :project_type, :location, :thumbnail)
      end

      def retrieve_project
        @retrieve_project ||= Project.find_by(id: params[:id])
      end

      def serialized_project(projects)
        projects.includes(:contents).map do |project|
          project&.serializable_hash&.merge(contents: project.contents)
        end
      end
    end
  end
end
