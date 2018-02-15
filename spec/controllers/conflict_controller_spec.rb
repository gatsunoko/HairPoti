require 'rails_helper'

RSpec.describe ConflictController, type: :controller do
  describe 'Conflictコントローラテスト' do
    subject do
      create_list(:picture, record_count, length: 'ショート')
      create_list(:picture, record_count, length: 'ロング')
    end

    context 'ログインしていない場合' do
      describe 'パラメーターに合致するレコードが10個未満の場合' do
        let(:record_count) { 4 }

        it 'トップページに戻る' do
          subject
          get 'index', params: { area: '全国', length: [ 'ショート', 'ロング'] }
          expect(response.status).to be >= 300
          expect(response.status).to be < 400
          expect(response).to redirect_to root_path
        end 
      end

      describe 'パラメーターに合致するレコードが10個以上の場合' do
        let(:record_count) { 15 }

        it 'indexが表示できる' do
          subject
          get 'index', params: { area: '全国', length: [ 'ショート', 'ロング'] }
          expect(response).to render_template :index
        end
      end
    end

    context '一般ユーザーでログインしていた場合' do
      let(:user) { create(:user, admin: false) }
      let(:record_count) { 15 }
      before(:each) do
        login_user user
      end

      it 'indexが表示できる' do
        subject
        get 'index'
        expect(response).to render_template :index
      end
    end
  end
end
