# Preview all emails at http://localhost:3000/rails/mailers/farm_mailer
class FarmMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/farm_mailer/farm_information
  def farm_information
    FarmMailer.farm_information
  end

end
