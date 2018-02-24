require 'rails_helper'

RSpec.describe PicturesController, type: :controller do
  describe 'picturesコントローラ' do
    context 'ログインしていない場合' do
      context 'index' do
        before(:each) do
          get 'index'
        end
        it 'レスポンスが200ではない' do
          expect(response.status).to_not eq 200
        end

        it 'indexにアクセスできない' do
          expect(response).to_not render_template :index
        end
      end

      context 'show' do
        render_views
        it 'スタイリストが投稿したshowを表示できる' do 
          @user = create(:user, role: 'stylist', admin: false)
          create(:stylist, user_id: @user.id)
          @picture = create(:picture, user_id: @user.id)
          get 'show', params: { id: @picture.id }
          expect(assigns(:picture)).to eq @picture #アクションが正常に実行
          expect(response).to render_template :show #テンプレートが正常に表示
        end

        it '管理者が投稿したshowを表示できる' do 
          @user = create(:user, role: 'admin', admin: true)
          @picture = create(:picture, user_id: @user.id)
          get 'show', params: { id: @picture.id }
          expect(assigns(:picture)).to eq @picture #アクションが正常に実行
          expect(response).to render_template :show #テンプレートが正常に表示
        end
      end
    end
  end
end