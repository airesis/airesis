class UserSensitive < ActiveRecord::Base
  belongs_to :sys_document_type
  belongs_to :user
  belongs_to :birth_place, class_name: 'InterestBorder', foreign_key: :birth_place_id
  belongs_to :home_place, class_name: 'InterestBorder', foreign_key: :home_place_id
  belongs_to :residence_place, class_name: 'InterestBorder', foreign_key: :residence_place_id

  # Check for paperclip
  has_attached_file :document,
                    s3_permissions: :private,
                    url: ':user_sensitives/:id/documents/:basename.:extension',
                    path: ':user_sensitives/:id/documents/:basename.:extension'


  validates_presence_of :name, :surname, :user_id, :tax_code

  after_create :update_user

  def update_user
    user.update_columns(name: name, surname: surname, user_type_id: UserType::CERTIFIED)
  end

end
