require 'rails_helper'

RSpec.describe PicturesController, type: :controller do
  describe 'ログインしていない場合' do
    per = 24
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
    end

    context 'show_modal' do
      render_views
      it 'スタイリストが投稿したshowをmodalで表示できる' do 
        @user = create(:user, role: 'stylist', admin: false)
        create(:stylist, user_id: @user.id)
        @picture = create(:picture, user_id: @user.id)
        get 'show_modal', params: { id: @picture.id }
        expect(assigns(:picture)).to eq @picture #アクションが正常に実行
        expect(response).to render_template :show #テンプレートが正常に表示
      end
    end

    context 'search' do
      render_views
      subject do
        @user = create(:user, id: 1)
        create(:stylist, user_id: @user.id, shop_address: '愛知')
        create_list(:picture, record_count, length: length1)
        create_list(:picture, record_count, length: length2)
      end

      context 'エリアが愛知で長さがショートとロングがそれぞれ15件' do
        let(:record_count) { 15 }
        let(:length1) { 'short' }
        let(:length2) { 'long' }

        it 'エリアパラメーターが愛知で検索結果が24件以上ある場合は24件(kaminari 1ページ分)を取得してindexが表示できる' do
          subject
          get 'search', params: { area: '愛知', length: [ 'short', 'long'] }
          expect(assigns(:pictures).count).to eq per
          expect(response).to render_template 'homes/index'
        end

        it 'lengthがショートの件数が15件でエリア未指定の場合、ショートで検索すると15件表示される' do
          subject
          get 'search', params: { area: '愛知', length: [ 'short'] }
          expect(assigns(:pictures).count).to eq 15
          expect(response).to render_template 'homes/index'
        end
      end
    end
  end

  describe 'スタイリストとしてログインしている場合' do
    before(:each) do
      @user = create(:user, role: 2, admin: false)
      @user2 = create(:user, role: 2, admin: false)
      login_user @user
    end

    context 'index' do
      render_views
      before(:each) do
        3.times {
          @picture = create(:picture, length: 'short', user_id: @user.id)
          @picture = create(:picture, length: 'short', user_id: @user2.id)
        }        
      end
      it '自分が投稿した画像だけが表示される' do
        get 'index'
        expect(assigns(:pictures).count).to eq 3
        expect(response).to render_template :index
      end
    end

    context 'new' do
      render_views
      it 'newにアクセスできる' do
        get 'new'
        expect(response.status).to eq 200
        expect(response).to render_template :new
      end
    end

    context 'update' do
      it '自分が投稿した画像ならばupdateできる' do
        @picture = create(:picture, user_id: @user.id)
        expect(@picture.text).to_not eq 'after update'
        patch 'update', params: { id: @picture.id, picture: { text: 'after update' } }
        expect(assigns(:picture)).to eq @picture
        expect(assigns(:picture).text).to eq 'after update'
        expect(Picture.find(@picture.id).text).to eq 'after update'
      end

      it '他者が投稿した画像はupdateできずroot_patにリダイレクトされる' do
        @picture = create(:picture, user_id: @user2.id, text: 'text')
        expect(@picture.text).to eq 'text'
        patch 'update', params: { id: @picture.id, picture: { text: 'after update' } }
        expect(Picture.find(@picture.id).text).to_not eq 'after update'

        expect(response.status).to be >= 300
        expect(response.status).to be < 400
        expect(response).to redirect_to root_path
      end
    end
  end

  describe '管理者としてログインしている場合' do
    before(:each) do
      @user = create(:user, role: 3, admin: true)
      @user2 = create(:user, role: 2, admin: false)
      login_user @user
    end

    context 'index' do
      render_views
      before(:each) do
        3.times {
          @picture = create(:picture, length: 'short', user_id: @user.id)
          @picture = create(:picture, length: 'short', user_id: @user2.id)
        }        
      end
      it 'すべてのユーザーが投稿した画像が表示される' do
        get 'index'
        expect(assigns(:pictures).count).to eq 6
        expect(response).to render_template :index
      end
    end

    context 'new' do
      render_views
      it 'newにアクセスできない' do
        get 'new'
        expect(response.status).to be >= 300
        expect(response.status).to be < 400
        expect(response).to_not render_template :new
      end
    end
  end
end
