require 'rails_helper'

RSpec.describe User, type: :model do
  # インスタンス生成
  before do
    @user = FactoryBot.build(:user)
  end

  # ユーザー新規登録のテストコード
  describe 'ユーザー新規登録' do

    it 'nameが空では登録されない' do
      @user.name = ''
      @user.valid?
      expect(@user.errors.full_messages).to include("ユーザー名を入力してください")
    end

    it 'emailが空では登録されない' do
      @user.email = ''
      @user.valid?
      expect(@user.errors.full_messages).to include("Eメールを入力してください")
    end
  end
end
