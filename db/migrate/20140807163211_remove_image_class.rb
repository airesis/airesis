class RemoveImageClass < ActiveRecord::Migration
  def up
    add_attachment :users, :avatar
    User.reset_column_information
    User.all.each do |user|
      if user.image && user.image.valid? && user.image.exists?
        user.avatar = user.image.image
        user.save
        #todo rimuovore image nella versione 4.1. le immagini non valide o non presenti verranno cancellate
      end
    end
  end

  def down
    remove_attachment :users, :avatar
  end
end
