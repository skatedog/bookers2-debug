class GroupMailer < ApplicationMailer
  def send_email(email_addresses,title,content)
    email_addresses = email_addresses
    @title = title
    @content = content
    mail(
      from: "送信元のメールアドレス",
      to: email_addresses,
      subject: title
    )
  end
end
