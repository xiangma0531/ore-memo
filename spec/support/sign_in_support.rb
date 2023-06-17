module SignInSupport
  def sign_in(user)
    visit root_path
    fill_in 'Eメール', with: user.email
    fill_in 'パスワード', with: user.password
    find('input[name="commit"]').click
  end
end