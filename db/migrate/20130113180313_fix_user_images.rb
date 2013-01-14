class FixUserImages < ActiveRecord::Migration
  def up
    #metti a nil tutte le images vuote
    User.update_all({:blog_image_url => nil},{:blog_image_url => ''})
    User.all.each do |user|
      unless user.valid?
        if user.errors.has_key?(:blog_image_url)
          user.blog_image_url = nil
          user.save
        end
      end
    end
  end

  def down
  end
end
