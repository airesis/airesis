class ElaborateEmails
  def perform(*_args)
    ReceivedEmail.where(read: false).each do |email|
      email.update!(read: true)
      topic = Frm::Topic.find_by(token: email.token)
      unless topic
        post = Frm::Post.find_by(token: email.token)
        topic = post.topic if post
      end
      user = User.find_by(email: email.from)
      next unless topic && user
      next unless user.can_reply_to_forem_topic?(topic)

      new_post = topic.posts.build
      new_post.user = user
      new_post.text = EmailReplyParser.parse_reply(email.body).gsub(/\d\d\d\d-\d\d-\d\d \d\d:\d\d.*>:/, '')
      new_post.reply_to_id = post.id if post
      new_post.save!
    end
  end
end
