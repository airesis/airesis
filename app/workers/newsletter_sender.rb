class NewsletterSender
  @queue = :newsletter
    
  def self.perform(params)
    receiver = params['mail']['receiver']
    puts receiver
    if receiver == 'all'
      @users = User.all
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
      ResqueMailer.publish(:subject => params['mail']['subject'], :user_id => user.id, :newsletter => params['mail']['name'] ).deliver
    end
  end
end