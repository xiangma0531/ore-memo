require 'rails_helper'

RSpec.describe "ユーザー新規登録", type: :system do
  before do
    @user = FactoryBot.build(:user)
  end

  context 'ユーザー新規登録ができるとき' do
    it '正しい情報を入力すればユーザー新規登録ができてトップページに移動する' do
      # トップページに移動する
      visit root_path
      # ログインしていない状態であればログインページに移動している
      expect(current_path).to eq(new_user_session_path)
      # 新規登録ページへ遷移するボタンがあることを確認する
      expect(page).to have_content('新規登録')
      # 新規登録ページに移動する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in 'ユーザー名', with: @user.name
      fill_in 'Eメール', with: @user.email
      fill_in 'パスワード', with: @user.password
      fill_in 'パスワード（確認用）', with: @user.password_confirmation
      # 登録ボタンを押すとユーザーモデルのカウントが1上がる
      expect{
        find('input[name="commit"]').click
      }.to change { User.count }.by(1)
      # トップページへ遷移したことを確認する
      expect(current_path).to eq(root_path)
      # 新規登録ボタンやログインボタンが表示されていない
      expect(page).to have_no_content('新規登録')
      expect(page).to have_no_content('ログイン')
    end
  end

  context 'ユーザー新規登録ができないとき' do
    it '誤った情報ではユーザー新規登録ができずに新規登録ページへ戻ってくる' do
      # トップページに移動する
      visit root_path
      # ログインしていない状態であれば新規登録ページに移動している
      expect(page).to have_content('新規登録')
      # 新規登録ページに移動する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in 'ユーザー名', with: ''
      fill_in 'Eメール', with: ''
      fill_in 'パスワード', with: ''
      fill_in 'パスワード（確認用）', with: ''
      # 登録ボタンを押してもユーザーモデルのカウントは上がらない
      expect{
        find('input[name="commit"]').click
      }.to change { User.count }.by(0)
      # 新規登録ページへ戻される
      expect(current_path).to eq user_registration_path
    end
  end

end

RSpec.describe "ユーザーログイン機能", type: :system do

    it 'ログインしていない状態でトップページにアクセスした場合、ログインページに移動する' do
      # トップページに移動する
      visit root_path
      # ログインしていない状態であればログインページに移動している
      expect(current_path).to eq(new_user_session_path)
    end

    it 'ログインに成功し、トップページに遷移する' do
      # あらかじめユーザーをDBに保存する
      @user = FactoryBot.create(:user)
      # ログインページに移動する
      visit new_user_session_path
      # すでに保存されているユーザーのemailとpasswordを入力する
      fill_in 'Eメール', with: @user.email
      fill_in 'パスワード', with: @user.password
      # ログインボタンをクリックする
      find('input[name="commit"]').click
      # トップページへ遷移したことを確認する
      expect(current_path).to eq(root_path)
      # 新規登録ボタンやログインボタンが表示されていない
      expect(page).to have_no_content('新規登録')
      expect(page).to have_no_content('ログイン')
      # ログインしているユーザー名が表示されている
      expect(page).to have_content(@user.name)
    end

    it 'ログインに失敗し、ログインページに戻ってくる' do
      # あらかじめユーザーをDBに保存する
      @user = FactoryBot.create(:user)
      # ログインページに移動する
      visit new_user_session_path
      # すでに保存されているユーザーとは異なるemailとpasswordを入力する
      fill_in 'Eメール', with: 'test'
      fill_in 'パスワード', with: 'test'
      # ログインボタンをクリックする
      find('input[name="commit"]').click
      # ログインページに戻ってきていることを確認する
      expect(current_path).to eq(new_user_session_path)
    end

end

RSpec.describe "ユーザー情報編集機能", type: :system do

  it 'ユーザー情報編集後入力した情報が反映されている' do
    # あらかじめユーザーをDBに保存する
    @user = FactoryBot.create(:user)
    # ログインページに移動する
    visit new_user_session_path
    # ログインする
    sign_in(@user)
    # トップページへ遷移したことを確認する
    expect(current_path).to eq(root_path)
    # 新規登録ボタンやログインボタンが表示されていない
    expect(page).to have_no_content('新規登録')
    expect(page).to have_no_content('ログイン')
    # ログインしているユーザー名が表示されている
    expect(page).to have_content(@user.name)
    # ユーザー情報編集画面へ遷移する
    visit edit_user_registration_path
    # 現在のユーザー名・メールアドレスが表示されている
    expect(
      find('#user_name').value
    ).to eq(@user.name)
    expect(
      find('#user_email').value
    ).to eq(@user.email)
    # ユーザー名・メールアドレス・パスワードを編集し、現在のパスワードを入力する
    fill_in 'ユーザー名', with: "#{@user.name}+編集"
    fill_in 'Eメール', with: "edit+#{@user.email}"
    fill_in 'パスワード', with: "edit#{@user.password}"
    fill_in 'パスワード（確認用）', with: "edit#{@user.password_confirmation}"
    fill_in '現在のパスワード', with: "#{@user.password}"
    # 更新ボタンをクリックする
    click_on('更 新')
    # ホーム画面に遷移し、変更されたユーザー名が表示されている
    expect(current_path).to eq(root_path)
    expect(page).to have_content("#{@user.name}+編集")
    # ログアウト後にログインページに移動している
    click_on('ログアウト')
    expect(current_path).to eq(new_user_session_path)
    # 再度ログインする際、変更前のメールアドレス・パスワードではログインできず、ログインページに戻される
    sign_in(@user)
    expect(current_path).to eq(new_user_session_path)
    # 再度ログインする際、変更後のメールアドレス・パスワードではログインでき、ホーム画面に遷移する
    fill_in 'Eメール', with: "edit+#{@user.email}"
    fill_in 'パスワード', with: "edit#{@user.password}"
    find('input[name="commit"]').click
    expect(current_path).to eq(root_path)
  end

end