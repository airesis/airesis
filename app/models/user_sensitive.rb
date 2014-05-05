class UserSensitive < ActiveRecord::Base
  belongs_to :sys_document_type
  belongs_to :user
  belongs_to :birth_place, class_name: 'InterestBorder', foreign_key: :birth_place_id
  belongs_to :home_place, class_name: 'InterestBorder', foreign_key: :home_place_id
  belongs_to :residence_place, class_name: 'InterestBorder', foreign_key: :residence_place_id

  # Check for paperclip
  has_attached_file :document,
                    url: ":rails_root/private/users/:id/documents/:basename.:extension",
                    path: ":rails_root/private/users/:id/documents/:basename.:extension"


  validates_presence_of :name, :surname, :user_id, :tax_code

  before_save :update_user

  def update_user
    self.user.name = self.name
    self.user.surname = self.surname
    self.user.user_type_id = UserType::CERTIFIED
    self.user.save!
  end

end
