require 'rails_helper'

RSpec.describe FollowsController, type: :controller do
  describe 'ログインしている場合' do
    before(:each) do
      @user = create(:user, role: 2, admin: false)
      @user2 = create(:user, role: 2, admin: false)
      login_user @user
    end
    subject do
      create_list(:follow, follow_count, user_id: @user.id, stylist_id: @user2.id)
      create_list(:follow, follower_count, user_id: @user2.id, stylist_id: @user.id)
    end

    context 'follow' do
      it '自分はフォローできない' do
        follow_count = Follow.all.count
        get 'follow', params: { id: @user.id }, xhr: true
        expect(response.status).to be >= 300
        expect(response.status).to be < 400
        expect(Follow.all.count).to eq follow_count
      end

      it '自分でなくフォローしていなければ、フォローできる' do
        follow_count = Follow.all.count
        get 'follow', params: { id: @user2.id }, xhr: true
        expect(response.status).to eq 200
        expect(Follow.all.count.to_i).to be > follow_count
      end

      it '既にフォローしていた場合、何も起こらない' do
        create(:follow, user_id: @user.id, stylist_id: @user2.id)
        follow_count = Follow.all.count
        get 'follow', params: { id: @user2.id }, xhr: true
        expect(response.status).to eq 200
        expect(Follow.all.count.to_i).to eq follow_count
      end
    end

    context 'stop_follow' do
      it 'フォローしていた場合、フォローが削除される' do
        create(:follow, user_id: @user.id, stylist_id: @user2.id)
        follow_count = Follow.all.count
        get 'stop_follow', params: { id: @user2.id }, xhr: true
        expect(Follow.all.count.to_i).to be < follow_count
      end
    end

    context 'followers' do
      render_views
      let(:follow_count) {5}
      let(:follower_count) {20}

      it 'フォロワーが20人、自分がフォローしている人が5人の場合、フォロワー20人が表示される' do
        subject
        get 'followers', params: { id: @user.id }
        expect(assigns(:followers).count).to eq 20
        expect(response).to render_template 'follows/followers'
      end
    end

    context 'follows' do
      render_views
      let(:follow_count) {5}
      let(:follower_count) {20}

      it 'フォロワーが20人、自分がフォローしている人が5人の場合、その5人が表示される' do
        subject
        get 'follows', params: { id: @user.id }
        expect(assigns(:followers).count).to eq 5
        expect(response).to render_template 'follows/follows'
      end
    end
  end
end