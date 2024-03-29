require 'rails_helper'

RSpec.describe Api::V1::ProjectsController do
  describe 'GET #index' do
    let(:index) { get :index }
    let!(:projects) { FactoryBot.create_list(:project, 5) }

    it 'returns successful response' do
      index

      expect(response).to be_successful
    end

    it 'returns list of existing project record from db' do
      index

      expect(JSON.parse(response.body)['data'].count).to eq(Project.count)
    end
  end

  describe 'GET #show' do
    let!(:project1) { FactoryBot.create(:project) }

    subject(:show) { get :show, params: }

    context 'when valid params provided' do
      let(:params) { { id: 'invalid_params' } }

      it 'returns status not found' do
        show

        expect(response).to be_not_found
      end

      it 'returns json with error message' do
        show

        expect(response.body).to eq({ error: 'Record not found.' }.to_json)
      end
    end

    context 'when valid params provided' do
      let(:params) { { id: project1.id } }

      it 'returns successful response' do
        show

        expect(response).to be_successful
      end

      it 'returns correct requested project record' do
        show

        expect(JSON.parse(response.body)['data']['id']).to eq(project1.id.to_s)
      end

      it 'returns serialized json-api' do
        show

        response_body = JSON.parse(response.body)
        expect(response_body['data'].keys).to eq(%w[id type attributes])
        expect(response_body['data']['attributes'].keys).to eq(%w[title thumbnail description
                                                                  location projectType ownerName createdAt updatedAt])
      end
    end
  end

  describe 'POST #create' do
    let(:user1) { FactoryBot.create(:user) }
    let(:params) do
      {
        title: 'PROJECT API',
        description: 'TEST APP',
        project_type: 'in_house',
        location: 'NP',
        thumbnail: Rack::Test::UploadedFile.new('spec/fixtures/files/thumbnail.jpg')
      }
    end

    subject(:create) { post :create, params: }

    context 'when user is not logged-in/authenticated' do
      let(:error_response) { { message: 'Please log in' } }

      it 'returns unauthorized error' do
        create

        expect(response).to be_unauthorized
      end

      it 'returns error with message' do
        create

        expect(response.body).to eq(error_response.to_json)
      end
    end

    context 'when user is logged-in/authenticated' do
      before { request.headers.merge!(user1.create_test_auth_header) }

      context 'with valid params' do
        it 'creates a new record in project table' do
          expect { create }.to change { Project.count }.by(1)
        end

        it 'returns created response' do
          create

          expect(response).to be_created
        end

        it 'returns serialized json-api' do
          create

          response_body = JSON.parse(response.body)
          expect(response_body['data'].keys).to eq(%w[id type attributes])
          expect(response_body['data']['attributes'].keys).to eq(%w[title thumbnail description
                                                                    location projectType ownerName createdAt updatedAt])
        end
      end

      context 'with invalid params' do
        let(:params) {}

        it 'does not create a new record in project table' do
          expect { create }.to change { Project.count }.by(0)
        end

        it 'returns unprocessable entity' do
          create

          expect(response).to be_unprocessable
        end
      end
    end
  end

  describe 'GET #user_projects' do
    let(:user) { FactoryBot.create(:user) }
    let!(:projects) { FactoryBot.create_list(:project, 5, user:) }
    let(:user_projects) { get :user_projects }

    context 'when user is not logged-in/authenticated' do
      let(:error_response) { { message: 'Please log in' } }

      it 'returns unauthorized error' do
        user_projects

        expect(response).to be_unauthorized
      end

      it 'returns error with message' do
        user_projects

        expect(response.body).to eq(error_response.to_json)
      end
    end

    context 'when user is logged-in/authenticated' do
      before { request.headers.merge!(user.create_test_auth_header) }

      it 'returns successful response' do
        user_projects

        expect(response).to be_successful
      end

      it 'returns total number of owned project record for logged in user' do
        user_projects

        expect(JSON.parse(response.body)['data'].count).to eq(5)
      end

      it 'returns serialized json-api' do
        user_projects

        response_body = JSON.parse(response.body)
        expect(response_body['data'].first.keys).to eq(%w[id type attributes])
        expect(response_body['data'].first['attributes'].keys).to eq(%w[title thumbnail description
                                                                        location projectType createdAt updatedAt])
      end
    end
  end

  describe 'PATCH #update' do
    let(:project) { FactoryBot.create(:project, user: user1) }
    let(:user1) { FactoryBot.create(:user) }
    let(:updated_title) { 'updated title' }
    let(:params) { { id: project.id, title: updated_title } }

    subject(:update) { patch :update, params: }

    context 'when user is not logged-in/authenticated' do
      let(:error_response) { { message: 'Please log in' } }

      it 'does not update the project record' do
        update

        expect(project.reload.title).not_to eq(updated_title)
      end

      it 'returns unauthorized error' do
        update

        expect(response).to be_unauthorized
      end

      it 'returns error with message' do
        update

        expect(response.body).to eq(error_response.to_json)
      end
    end

    context 'when user is logged-in/authenticated' do
      context 'when user is owner of project' do
        before { request.headers.merge!(user1.create_test_auth_header) }

        it 'updates the project record' do
          update

          expect(project.reload.title).to eq(updated_title)
        end

        it 'returns successful response' do
          update

          expect(response).to be_successful
        end
      end

      context 'when user is not owner of project' do
        let(:user2) { FactoryBot.create(:user) }

        before { request.headers.merge!(user2.create_test_auth_header) }

        it 'does not update the project record' do
          update

          expect(project.reload.title).not_to eq(updated_title)
        end

        it 'returns unprocessable entity' do
          update

          expect(response).to be_unprocessable
        end

        it 'returns error message' do
          update

          expect(response.body).to eq({ error: 'Something went wrong. Please contact support' }.to_json)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user1) { FactoryBot.create(:user) }
    let!(:project) { FactoryBot.create(:project, user: user1) }
    let(:params) { { id: project.id } }

    subject(:destroy) { delete :destroy, params: }

    context 'when user is not logged-in/authenticated' do
      let(:error_response) { { message: 'Please log in' } }

      it 'does not delete project record' do
        expect { destroy }.to_not change(Project, :count)
      end

      it 'returns unauthorized error' do
        destroy

        expect(response).to be_unauthorized
      end

      it 'returns error with message' do
        destroy

        expect(response.body).to eq(error_response.to_json)
      end
    end

    context 'when user is logged-in/authenticated' do
      context 'when user is owner of project' do
        before { request.headers.merge!(user1.create_test_auth_header) }

        it 'deletes a project record' do
          expect { destroy }.to change(Project, :count).by(-1)
        end

        it 'returns successful response' do
          destroy

          expect(response).to be_successful
        end

        it 'returns message' do
          destroy

          expect(response.body).to eq({ message: 'Deleted' }.to_json)
        end
      end

      context 'when user is not owner of project' do
        let(:user2) { FactoryBot.create(:user) }

        before { request.headers.merge!(user2.create_test_auth_header) }

        it 'does not delete project record' do
          expect { destroy }.to_not change(Project, :count)
        end

        it 'returns unprocessable entity' do
          destroy

          expect(response).to be_unprocessable
        end

        it 'returns error message' do
          destroy

          expect(response.body).to eq({ error: 'Something went wrong. Please contact support' }.to_json)
        end
      end
    end
  end
end
