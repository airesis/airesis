class GeocodeUser
  @queue = :geocode


  def self.perform(*args)
    user_id = args[0]
    @user = User.find_by_id(user_id)
    @user.geocode
  end

end
