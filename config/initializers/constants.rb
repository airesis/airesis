#look at application.example.yml for an explanation of variables
#todo move specific model configuration variables in models
#maximum date for repeating events
END_TIME = Date.parse("1 Jan, 2016").to_time
CONTRIBUTE_MAX_LENGTH = (ENV['CONTRIBUTE_MAX_LENGTH'] || 2000).to_i
DEFAULT_CHANGE_ADVANCED_OPTIONS = (ENV['DEFAULT_CHANGE_ADVANCED_OPTIONS'].try(:downcase) == "true")
DEFAULT_ANONIMA = (ENV['DEFAULT_ANONIMA'].try(:downcase) == "true")
DEFAULT_GROUP_ACTIONS = ENV['DEFAULT_GROUP_ACTIONS'].split(',').map(&:to_i)
DEFAULT_AREA_ACTIONS = ENV['DEFAULT_AREA_ACTIONS'].split(',').map(&:to_i)
CONTRIBUTE_MARKS = (ENV['CONTRIBUTE_MARKS'] || 3).to_i
DEBATE_VOTE_DIFFERENCE = (ENV['DEBATE_VOTE_DIFFERENCE'] || 10).to_i.minutes
COMMENTS_PER_PAGE = (ENV['COMMENTS_PER_PAGE'] || 5).to_i
PROPOSALS_PER_PAGE = (ENV['PROPOSALS_PER_PAGE'] || 10).to_i
TOPICS_PER_PAGE = (ENV['TOPICS_PER_PAGE'] || 10).to_i
LIMIT_COMMENTS = (ENV['LIMIT_COMMENTS'].try(:downcase) == "true")
COMMENTS_TIME_LIMIT = (ENV['COMMENTS_TIME_LIMIT'] || 30).to_i.seconds
LIMIT_PROPOSALS = (ENV['LIMIT_PROPOSALS'].try(:downcase) == "true")
PROPOSALS_TIME_LIMIT = (ENV['PROPOSALS_TIME_LIMIT'] || 60).to_i.seconds
LIMIT_GROUPS = (ENV['LIMIT_GROUPS'].try(:downcase) == "true")
GROUPS_TIME_LIMIT = (ENV['GROUPS_TIME_LIMIT'] || 24).to_i.hours
ROTP_DRIFT = (ENV['ROTP_DRIFT'].to_i || 20)
OTHERS_CHOOSE_VOTE_DATE_DAYS = (ENV['OTHERS_CHOOSE_VOTE_DATE_DAYS'] || 5).to_i
