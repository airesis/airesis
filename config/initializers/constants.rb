#quando si creano eventi che si ripetono per sempre li crea fino a questa data
END_TIME = Date.parse("1 Jan, 2016").to_time

POSITIVE_VALUTATION = 1
NEUTRAL_VALUTATION = 2
NEGATIVE_VALUTATION = 3


PROP_VALUT=1
PROP_WAIT_DATE=2
PROP_WAIT=3
PROP_VOTING=4
PROP_RESP=5
PROP_ACCEPT=6
PROP_REVISION=7

CONTRIBUTE_MAX_LENGTH = 2000

DEFAULT_CHANGE_ADVANCED_OPTIONS = false
DEFAULT_ANONIMA = true
DEFAULT_GROUP_ACTIONS = [1,2,6,7,8,9,11,12]
DEFAULT_AREA_ACTIONS = [6,7,8,11,12]

CONTRIBUTE_MARKS = 3

DEBATE_VOTE_DIFFERENCE = 10.minutes

#indirizzo del sito
SITE="http://airesisdev.it:3000"
#numero massimo di commenti per pagina
COMMENTS_PER_PAGE=5
#numero massimo di proposte per pagina
PROPOSALS_PER_PAGE=10

#topics per page
TOPICS_PER_PAGE=10

#numero di giorni senza aggiornamenti dopo i quali la proposta viene abolita
PROP_DAY_STALLED=2

#limita il numero di commenti
LIMIT_COMMENTS=false
COMMENTS_TIME_LIMIT=30.seconds

#limita il numero di proposte
LIMIT_PROPOSALS=false
PROPOSALS_TIME_LIMIT=1.minute

#limita il numero di gruppi
LIMIT_GROUPS=true
GROUPS_TIME_LIMIT=24.hours

ROTP_DRIFT = 20
