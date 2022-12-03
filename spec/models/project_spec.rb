require 'rails_helper'

RSpec.describe Project, type: :model do
  describe '.validations for project' do
    let(:user1) { FactoryBot.create(:user) }
    let!(:project) { FactoryBot.create(:project, title: 'project_1', user: user1) }

    context 'when project with title and user id already exists' do
      context 'when the user_id is same as existing project record' do
        subject { FactoryBot.create(:project, title: 'project_1', user: user1) }

        it 'does not create a new record in project' do
          expect do
            subject
          end.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Title has already been taken')
        end
      end

      context 'when the user_id is different from existing project record' do
        let(:user2) { FactoryBot.create(:user) }
        subject { FactoryBot.create(:project, title: 'project_1', user: user2) }

        it 'creates a new project record' do
          expect { subject }.to change(Project, :count).by(1)
        end
      end
    end

    context 'when project with title and user id does not exist' do
      let(:user3) { FactoryBot.create(:user) }
      subject { FactoryBot.create(:project, title: 'project_3', user: user3) }

      it 'creates a new project record' do
        expect { subject }.to change(Project, :count).by(1)
      end
    end
  end
end
