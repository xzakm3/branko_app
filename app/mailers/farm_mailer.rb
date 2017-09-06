class FarmMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.farm_mailer.farm_information.subject
  #
  def farm_information(user, death_info, hatch_info)
    @deaths = death_info
    @hatches = hatch_info
    @user = user
    attachments.inline["logo.png"] = File.read("#{Rails.root}/app/assets/images/logo2.png")
    mail to: "zakyz.martin@gmail.com", subject: "[Farma #{user.farm.name}] - INFO ", from: user.email
  end
end
