require 'rails_helper'

RSpec.describe "メモ投稿", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @image_path = Rails.root.join('public/images/dammy.png')
  end

  context 'メモの投稿ができるとき' do
    it 'ログインしたユーザーは新規投稿できる' do
      # ログインする
      sign_in(@user)
      # 新規投稿ページへのボタンが表示されている
      expect(page).to have_content('+')
      # 投稿ページに遷移する
      visit new_memo_path
      # フォームに情報を入力する
      fill_in 'タイトル', with: 'タイトル'
      fill_in '内容', with: Faker::Lorem.sentence
      attach_file('memo[image]', @image_path, make_visible: true)
      # 「作成」ボタンをクリックすると、Memoモデルのカウントが1上がる
      expect{
        find('input[name="commit"]').click
      }.to change { Memo.count }.by(1)
      # ホーム画面に遷移する
      expect(current_path).to eq(root_path)
      # ホーム画面に投稿したメモが表示されている
      expect(page).to have_content('タイトル')
    end
  end

  context 'メモの投稿ができないとき' do
    it 'ログインしていないと新規投稿ページに遷移できない' do
      # ホーム画面に遷移する
      visit root_path
      # 新規投稿ページへのボタンが表示されていない
      expect(page).to have_no_content('+')
    end

    it '入力項目が空のとき、メモの投稿に失敗する' do
      # ログインする
      sign_in(@user)
      # 新規投稿ページへのボタンが表示されている
      expect(page).to have_content('+')
      # 投稿ページに遷移する
      visit new_memo_path
      # 何も入力せずに「作成ボタン」をクリックすると、新規投稿画面に戻り、Memoモデルのカウントも増えない
      fill_in 'タイトル', with: ''
      fill_in '内容', with: ''
      expect{
        find('input[name="commit"]').click
      }.to change { Memo.count }.by(0)
      expect(current_path).to eq(memos_path)
    end
  end

end

RSpec.describe "メモ編集", type: :system do
  before do
    @memo1 = FactoryBot.create(:memo)
    @memo2 = FactoryBot.create(:memo)
    @image_path = Rails.root.join('public/images/dammy2.png')
  end

  context 'メモの編集ができるとき' do
    it 'ログインしたユーザーはメモの編集できる' do
      # memo1を投稿したユーザーとしてログインする
      sign_in(@memo1.user)
      # 過去に投稿したメモが表示されている
      expect(page).to have_content(@memo1.title)
      # 詳細ページへ遷移する
      visit memo_path(@memo1)
      # 「編集」ボタンが表示されている
      expect(page).to have_content('編集')
      # メモ編集ページに遷移する
      visit edit_memo_path(@memo1)
      # フォームに情報を入力する
      fill_in 'タイトル', with: "編集#{@memo1.title}"
      fill_in '内容', with: "編集#{@memo1.content}"
      # 「作成」ボタンをクリックしても、Memoモデルのカウントは増えない
      expect{
        find('input[name="commit"]').click
      }.to change { Memo.count }.by(0)
      # 詳細画面に遷移する
      expect(current_path).to eq(memo_path(@memo1))
      # 詳細画面に編集したメモが表示されている
      expect(page).to have_content("編集#{@memo1.title}")
      expect(page).to have_content("編集#{@memo1.content}")
    end
  end

  context 'メモの編集ができないとき' do
    it '自分以外のユーザーが投稿したメモは編集できない' do
      # memo2を投稿したユーザーとしてログインする
      sign_in(@memo2.user)
      # memo1が投稿したメモは表示されていない
      expect(page).to have_no_content(@memo1.title)
    end
  end

end