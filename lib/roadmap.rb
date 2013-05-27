class Roadmap
  include HTTParty

  base_uri 'bugtracking.alwaysdata.net'

  def initialize(u, p)
    @auth = {:username => u, :password => p}
  end

  def versions
    self.class.get("/projects/airesis/versions.xml")
  end
end
