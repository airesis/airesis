class Roadmap
  include HTTParty

  base_uri ENV['BUGTRACKING_URL']

  def initialize(u, p)
    @auth = { username: u, password: p }
  end

  def versions
    self.class.get('/projects/airesis/versions.xml')
  end

  def issues
    self.class.get('/projects/airesis/issues.xml?tracker_id=2&limit=100&status_id=*&cf_13=1')
  end
end
