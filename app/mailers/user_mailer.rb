class UserMailer < ApplicationMailer
  default from: "no-reply@#{ENV['ORE_MEMO_DOMAIN']}"

  def account_activation(user)
    @user = user
    @url = "https://#{ENV['ORE_MEMO_DOMAIN']}"
    mail(to: @user.email, subject: 'アカウント登録が完了しました')
  end
end
