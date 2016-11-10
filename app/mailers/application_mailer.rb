class ApplicationMailer < ActionMailer::Base
  default from: "App Jonny v2 <a.app.jonny@yandex.ru>", to: "pukman.victor@gmail.com"
  layout 'mailer'
end
