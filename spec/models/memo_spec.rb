require 'rails_helper'

RSpec.describe Memo, type: :model do
  # インスタンス生成
  before do
    @memo = FactoryBot.build(:memo)
  end

  # メモの投稿に関するテストコード
  describe 'メモの投稿' do
    
    # 正常系
    context '新規登録できる場合' do

      it 'titleとcontentが入力されていれば登録できる' do
        @memo.image = nil
        expect(@memo).to be_valid
      end

      it 'titleの入力とimageの添付ができていれば登録できる' do
        @memo.content = ''
        expect(@memo).to be_valid
      end

      it 'titleとcontentの入力とimageの添付ができていれば登録できる' do
        expect(@memo).to be_valid
      end

    end

    # 異常系
    context '新規登録できない場合' do

      it 'titleとcontentが未入力かつimageが添付されていない場合登録できない' do
        @memo.title = ''
        @memo.content = ''
        @memo.image = nil
        @memo.valid?
        expect(@memo.errors.full_messages).to include("タイトルを入力してください", "内容を入力してください")
      end
      
      it 'titleが空の場合登録できない' do
        @memo.title = ''
        @memo.valid?
        expect(@memo.errors.full_messages).to include("タイトルを入力してください")
      end

      it 'contentとimageがともに空の場合登録できない' do
        @memo.content = ''
        @memo.image = nil
        @memo.valid?
        expect(@memo.errors.full_messages).to include("内容を入力してください")
      end

      it 'userが紐づいていないと登録できない' do
        @memo.user = nil
        @memo.valid?
        expect(@memo.errors.full_messages).to include("Userを入力してください")
      end
      
    end
  end

end
