class NewsletterSender
  include Sidekiq::Worker
    
  def perform(params)
    receiver = params['mail']['receiver']
    puts receiver
    if receiver == 'all'
      @users = User.confirmed.where({blocked: false, receive_newsletter: true}).where('email is not null')
    elsif receiver == 'not_confirmed'
      @users = User.unconfirmed.all
    elsif receiver == 'test'
      @users = User.all(limit: 1)
    elsif receiver == 'admin'
      @users = User.find_all_by_login('admin')
    elsif receiver == 'portavoce'
      raise Exception
    end
    puts @users
    @users.each do |user|
      puts '---' + user.fullname
      ResqueMailer.delay.publish(subject: params['mail']['subject'], user_id: user.id, newsletter: params['mail']['name'] )
    end
  end
end