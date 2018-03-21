require 'rails_helper'

RSpec.describe LikesController, type: :controller do
  describe 'ログインしている場合' do
    context 'likes' do
      render_views
      before(:each) do
        @user = create(:user)
        login_user @user
        10.times {
          @picture = create(:picture, length: 'short', user_id: @user.id)
          create(:like, user_id: @user.id, picture_id: @picture.id)
        }
      end

      it 'お気に入り一覧ページが表示できる' do
        get 'likes'
        expect(response).to render_template 'likes'
      end

      it 'お気に入り登録が10件ある場合、10件取得できる' do
        get 'likes'
        expect(assigns(:likes).count).to eq 10
      end
    end
  end

  describe 'ログインしていない場合' do
    it 'お気に入り一覧ページが表示できず別ページにリダイレクトされる' do
      get 'likes'
      expect(response).to_not render_template 'likes'
      expect(response.status).to be >= 300
      expect(response.status).to be < 400
    end
  end
end
