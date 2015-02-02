#quando si creano eventi che si ripetono per sempre li crea fino a questa data
END_TIME = Date.parse("1 Jan, 2016").to_time

#the maximum length for a contribute in a proposal
CONTRIBUTE_MAX_LENGTH = 2000

#default value in groups for the option 'allow users to change options'
DEFAULT_CHANGE_ADVANCED_OPTIONS = false
#default value in groups for the option 'anonimous discussion'
DEFAULT_ANONIMA = true

#actions enabled by default for users when they join a group (the group can always change them but these are proposed by default)
DEFAULT_GROUP_ACTIONS = [1,2,6,7,8,9,11,12]
#actions enabled by default for users when they join a group area (the group can always change them but these are proposed by default)
DEFAULT_AREA_ACTIONS = [6,7,8,11,12]

#minimum amount of marks for a contribute to be eligible for deletion
CONTRIBUTE_MARKS = 3
#minimum amount of time between the end of debate and the beginning of vote. please do not set it below few minutes.
DEBATE_VOTE_DIFFERENCE = 10.minutes

#max number of comments per page
COMMENTS_PER_PAGE=5
#max number of proposals per page
PROPOSALS_PER_PAGE=10

#max number of topics per page
TOPICS_PER_PAGE=10

#contributes and comments are limited for each user?
LIMIT_COMMENTS=false
#if contributes and comments are limited this is the minimum amount of time between two subsequent comments from the same user
COMMENTS_TIME_LIMIT=30.seconds

#proposals are limited for each user?
LIMIT_PROPOSALS=false
#if proposals are limited this is the minimum amount of time between two subsequent proposals from the same user
PROPOSALS_TIME_LIMIT=1.minute

#groups creation is limited?
LIMIT_GROUPS=true
#if groups creation is limited this is the minimum amount of time between two subsequent creations from the same user
GROUPS_TIME_LIMIT=24.hours

#if you are using tokens for voting yoy may need to set a drift for token creation.
ROTP_DRIFT = 20
