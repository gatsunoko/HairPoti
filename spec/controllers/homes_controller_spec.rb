require 'rails_helper'

RSpec.describe HomesController, type: :controller do
  describe 'Homesコントローラテスト' do
    render_views
    context 'ログインしていない場合' do
      it 'indexが表示できる' do
        get 'index'
        expect(response).to render_template :index
      end
    end

    context '一般ユーザーでログインしていた場合' do
      let(:user) { create(:user, admin: false) }
      before(:each) do
        login_user user
      end

      it 'indexが表示できる' do
        get 'index'
        expect(response).to render_template :index
      end

      it 'followsが表示できる' do
        get 'follows'
        expect(response).to render_template :index
      end
    end
  end
end
