require 'rails_helper'

RSpec.describe User, type: :model do
  # インスタンス生成
  before do
    @user = FactoryBot.build(:user)
  end

  # ユーザー新規登録のテストコード
  describe 'ユーザー新規登録' do
    # 正常系
    context '新規登録できる場合' do
      it 'nameとemail、passwordとpassword_confiamationが存在すれば登録できる' do
        expect(@user).to be_valid
      end
    end

    # 異常系
    context '新規登録できない場合' do

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

      it 'passwordが空では登録できない' do
        @user.password = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("パスワードを入力してください")
      end

      it 'passwordが5文字以下では登録できない' do
        @user.password = '12345'
        @user.password_confirmation = '12345'
        @user.valid?
        expect(@user.errors.full_messages).to include("パスワードは6文字以上で入力してください")
      end

      it 'passwordとpassword_confirtationが不一致では登録できない' do
        @user.password = '123456'
        @user.password_confirmation = '1234567'
        @user.valid?
        expect(@user.errors.full_messages).to include("パスワード（確認用）とパスワードの入力が一致しません")
      end

      it '重複したemailが存在する場合は登録できない' do
        @user.save
        another_user = FactoryBot.build(:user, email: @user.email)
        another_user.valid?
        expect(another_user.errors.full_messages).to include("Eメールはすでに存在します")
      end

      it 'emailは@を含まないと登録できない' do
        @user.email = 'testmail'
        @user.valid?
        expect(@user.errors.full_messages).to include("Eメールは不正な値です")
      end

    end

  end

end
