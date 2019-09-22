class RemoveLinkedinMeetup < ActiveRecord::Migration[5.2]
  def change
    Authentication.where(provider: ['linkedin', 'meetup']).delete_all
    remove_column :users, :linkedin_page_url, :string
  end
end
