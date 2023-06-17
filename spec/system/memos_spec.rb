require 'rails_helper'

RSpec.describe "メモ投稿", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @memo = FactoryBot.create(:memo)
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
      fill_in 'タイトル', with: @memo.title
      fill_in '内容', with: @memo.content
      attach_file('memo[image]', @image_path, make_visible: true)
      # 「作成」ボタンをクリックすると、Memoモデルのカウントが1上がる
      expect{
        find('input[name="commit"]').click
      }.to change { Memo.count }.by(1)
      # ホーム画面に遷移する
      expect(current_path).to eq(root_path)
      # ホーム画面に投稿したメモが表示されている
      expect(page).to have_content(@memo.title)
      # 詳細ページに遷移すると、投稿した画像がブラウザに表示されていることを確認する
      visit memo_path(@memo)
      expect(page).to have_selector('img')
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
    @image_path = Rails.root.join('public/images/dammy.png')
  end

  context 'メモの編集ができるとき' do
    it 'ログインしたユーザーはメモの編集ができる' do
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
      attach_file('memo[image]', @image_path, make_visible: true)
      # 「作成」ボタンをクリックしても、Memoモデルのカウントは増えない
      expect{
        find('input[name="commit"]').click
      }.to change { Memo.count }.by(0)
      # 詳細画面に遷移する
      expect(current_path).to eq(memo_path(@memo1))
      # 詳細画面に編集したメモと画像が表示されている
      expect(page).to have_content("編集#{@memo1.title}")
      expect(page).to have_content("編集#{@memo1.content}")
      expect(page).to have_selector('img')
    end
  end

  context 'メモの編集ができないとき' do
    it '自分以外のユーザーが投稿したメモは編集できない' do
      # memo2を投稿したユーザーとしてログインする
      sign_in(@memo2.user)
      # memo1は表示されていない
      expect(page).to have_no_content(@memo1.title)
    end
  end

end

RSpec.describe "メモ削除", type: :system do
  before do
    @memo1 = FactoryBot.create(:memo)
    @memo2 = FactoryBot.create(:memo)
  end

  context 'メモの削除ができるとき' do
    it 'ログインしたユーザーはメモの編集できる' do
      # memo1を投稿したユーザーとしてログインする
      sign_in(@memo1.user)
      # 過去に投稿したメモが表示されている
      expect(page).to have_content(@memo1.title)
      # 詳細ページへ遷移する
      visit memo_path(@memo1)
      # 「削除」ボタンが表示されている
      expect(page).to have_content('削除')
      # 「削除」ボタンをクリックすると削除モーダルが出現し、「削除する」ボタンと「キャンセル」ボタンが表示される
      find('#openModal').click
      expect(page).to have_content('削除する')
      expect(page).to have_content('キャンセル')
      # 「キャンセル」ボタンをクリックすると、メモは削除されず、モーダルが消える
      expect{
        find('#closeModal').click
      }.to change { Memo.count }.by(0)
      expect(page).to have_no_content('削除する')
      expect(page).to have_no_content('キャンセル')
      # モーダルの「削除」ボタンをクリックすると、Memoモデルのカウントが1減る
      find('#openModal').click
      expect{
        click_on('削除する')
      }.to change { Memo.count }.by(-1)
      # ホーム画面に遷移する
      expect(current_path).to eq(root_path)
      # ホーム画面に削除したメモは表示されていない
      expect(page).to have_no_content(@memo1.title)
    end
  end

  context 'メモの削除ができないとき' do
    it '自分以外のユーザーが投稿したメモは削除できない' do
      # memo2を投稿したユーザーとしてログインする
      sign_in(@memo2.user)
      # memo1は表示されていない
      expect(page).to have_no_content(@memo1.title)
    end
  end

end