#look at application.example.yml for an explanation of variables
#todo move specific model configuration variables in models
#maximum date for repeating events
END_TIME = Date.parse("1 Jan, 2016").to_time
CONTRIBUTE_MAX_LENGTH = ENV['CONTRIBUTE_MAX_LENGTH'].to_i || 2000
DEFAULT_CHANGE_ADVANCED_OPTIONS = (ENV['DEFAULT_CHANGE_ADVANCED_OPTIONS'].try(:downcase) == "true")
DEFAULT_ANONIMA = (ENV['DEFAULT_ANONIMA'].try(:downcase) == "true")
DEFAULT_GROUP_ACTIONS = ENV['DEFAULT_GROUP_ACTIONS'].split(',').map(&:to_i)
DEFAULT_AREA_ACTIONS = ENV['DEFAULT_AREA_ACTIONS'].split(',').map(&:to_i)
CONTRIBUTE_MARKS = ENV['CONTRIBUTE_MARKS'].to_i || 3
DEBATE_VOTE_DIFFERENCE = (ENV['DEBATE_VOTE_DIFFERENCE'].to_i || 10).minutes
COMMENTS_PER_PAGE = ENV['COMMENTS_PER_PAGE'].to_i || 5
PROPOSALS_PER_PAGE = ENV['PROPOSALS_PER_PAGE'].to_i || 10
TOPICS_PER_PAGE = ENV['TOPICS_PER_PAGE'].to_i || 10
LIMIT_COMMENTS = (ENV['LIMIT_COMMENTS'].try(:downcase) == "true")
COMMENTS_TIME_LIMIT = (ENV['COMMENTS_TIME_LIMIT'].to_i || 30).seconds
LIMIT_PROPOSALS = (ENV['LIMIT_PROPOSALS'].try(:downcase) == "true")
PROPOSALS_TIME_LIMIT = (ENV['PROPOSALS_TIME_LIMIT'].to_i || 60).seconds
LIMIT_GROUPS = (ENV['LIMIT_GROUPS'].try(:downcase) == "true")
GROUPS_TIME_LIMIT = (ENV['GROUPS_TIME_LIMIT'].to_i || 24).hours
ROTP_DRIFT = (ENV['ROTP_DRIFT'].to_i || 20)
