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
        it 'showを表示できる' do 
          create(:user, id: 1)
          @picture = create(:picture)
          get 'show', params: { id: @picture.id }
          expect(assigns(:picture)).to eq @picture #アクションが正常に実行
          expect(response).to render_template :show #テンプレートが正常に表示
        end
      end
    end
  end
end
