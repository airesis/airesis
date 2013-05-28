class Roadmap
  include HTTParty

  base_uri BUGTRACKING_URL



  def initialize(u, p)
    @auth = {:username => u, :password => p}
  end

  def versions
    self.class.get("/projects/airesis/versions.xml")
  end

  def issues
    self.class.get("/projects/airesis/issues.xml")
  end
end
