class DefaultParametersForNotificationTypes < ActiveRecord::Migration
  def change
    names = %w(available_author new_contributes new_contributes_mine new_comments new_comments_mine new_blog_comment new_participation_request)
    NotificationType.where(name: names).update_all(cumulable: true) unless reverting?
  end
end
