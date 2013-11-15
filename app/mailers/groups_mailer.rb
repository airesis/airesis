#encoding: utf-8
#send information emails to group partecipants
class GroupsMailer < ActionMailer::Base
  include Resque::Mailer
  default from: "Airesis <noreply@airesis.it>"

  layout :choose_layout


  def few_users_a(group_id)
    @group  =Group.find(group_id)
    @user = @group.portavoce.first
      mail(:to => @user.email, :subject => "#{@group.name} non ha ancora dei partecipanti") if @user.email
  end

  protected

  def choose_layout
    'maktoub/newsletter_mailer'
  end
end
