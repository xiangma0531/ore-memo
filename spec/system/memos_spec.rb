require 'rails_helper'

RSpec.describe "メモ投稿", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @memo = FactoryBot.create(:memo)
  end

  context 'メモの投稿ができるとき' do
    it 'ログインしたユーザーは新規投稿できる' do
      # ログインする
      # 新規投稿ページへのボタンが表示されている
      # 投稿ページに遷移する
      # フォームに情報を入力する
      # 送信するとMemoモデルのカウントが1上がる
      # ホーム画面に遷移する
      # ホーム画面に投稿したメモが表示されている
    end
  end

  context 'メモの投稿ができないとき' do
    it 'ログインしていないと新規投稿ページに遷移できない' do
      # ホーム画面に遷移する
      # 新規投稿ページへのボタンが表示されていない
    end
  end

end
