class UserMailer < ApplicationMailer
  def delete_email(user)
    @user = user
    @url  = 'localhost:3000/users/new'
    mail(to: @user.email, subject: 'You are banished!')
  end
end
