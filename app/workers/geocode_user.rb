class GeocodeUser
  include Sidekiq::Worker

  def perform(*args)
    user_id = args[0]
    @user = User.find_by(id: user_id)
    @user.geocode
  end
end
