class ApplicationMailer < ActionMailer::Base
  default from: '送信元のメールアドレス'
  layout 'mailer'
end
