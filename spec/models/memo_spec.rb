require 'rails_helper'

RSpec.describe Memo, type: :model do
  # インスタンス生成
  before do
    @user = FactoryBot.build(:user)
  end

  # メモの投稿に関するテストコード
  describe 'メモの投稿' do
    
    # 正常系
    context '新規登録できる場合' do

      it 'タイトルとメモの内容が入力されていれば登録できる' do
        
      end

      it 'タイトルの入力と画像の添付ができていれば登録できる' do
        
      end

      it 'タイトルとメモの内容の入力と画像の添付ができていれば登録できる' do
        
      end

    end

    # 異常系
    context '新規登録できない場合' do
      
      it 'タイトルが空の場合登録できない' do
        
      end

      it 'メモの内容が未入力かつ画像が添付されていない場合登録できない' do
        
      end

      it 'userが紐づいていないと登録できない' do
        
      end
      
    end
  end

end
