require 'rails_helper'

RSpec.describe FollowsController, type: :controller do
  describe 'ログインしている場合' do
    before(:each) do
      @user = create(:user, role: 2, admin: false)
      @user2 = create(:user, role: 2, admin: false)
      login_user @user
    end

    context 'follow' do
      it '自分はフォローできない' do
        follow_count = Follow.all.count
        get 'follow', params: { id: @user.id }, xhr: true
        expect(response.status).to be >= 300
        expect(response.status).to be < 400
        expect(Follow.all.count).to eq follow_count
      end

      it '自分でなければフォローできる' do
        follow_count = Follow.all.count
        get 'follow', params: { id: @user2.id }, xhr: true
        expect(response.status).to eq 200
        expect(Follow.all.count.to_i).to_not eq follow_count
      end
    end
  end
end
