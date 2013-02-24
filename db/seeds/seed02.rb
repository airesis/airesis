#encoding: utf-8
EventType.create( :description => "incontro" ){ |c| c.id = 1 }.save
EventType.create( :description => "votazione" ){ |c| c.id = 2 }.save
EventType.create( :description => "riunione" ){ |c| c.id = 3 }.save
EventType.create( :description => "elezione" ){ |c| c.id = 4 }.save

GroupAction.create( :name => "STREAM_POST", :description => 'Pubblicare nella Home Page del gruppo'){ |c| c.id = 1 }.save
GroupAction.create( :name => "CREATE_EVENT", :description => 'Creare eventi e votazioni'){ |c| c.id = 2 }.save
GroupAction.create( :name => "PROPOSAL", :description => 'Sostenere proposte a nome del gruppo'){ |c| c.id = 3 }.save
GroupAction.create( :name => "REQUEST_ACCEPT", :description => 'Aggiungere partecipanti nel gruppo'){ |c| c.id = 4 }.save
GroupAction.create( :name => "SEND_CANDIDATES", :description => 'Candidare utenti alle elezioni'){ |c| c.id = 5 }.save
GroupAction.create( :name => "PROPOSAL_VIEW", :description => 'Visualizzare le proposte private'){ |c| c.id = 6 }.save
GroupAction.create( :name => "PROPOSAL_PARTECIPATION", :description => 'Contribuire alle proposte'){ |c| c.id = 7 }.save
GroupAction.create( :name => "PROPOSAL_INSERT", :description => 'Inserire nuove proposte nel gruppo'){ |c| c.id = 8 }.save

GroupPartecipationRequestStatus.create( :description => "Inoltrata" ){ |c| c.id = 1 }.save
GroupPartecipationRequestStatus.create( :description => "In votazione" ){ |c| c.id = 2 }.save
GroupPartecipationRequestStatus.create( :description => "Accettata" ){ |c| c.id = 3 }.save
GroupPartecipationRequestStatus.create( :description => "Negata" ){ |c| c.id = 4 }.save

NotificationCategory.create( :description => "Proposte" ){ |c| c.id = 1 }.save
NotificationCategory.create( :description => "Sondaggi" ){ |c| c.id = 2 }.save
NotificationCategory.create( :description => "Gruppi" ){ |c| c.id = 3 }.save
NotificationCategory.create( :description => "Eventi" ){ |c| c.id = 4 }.save
NotificationCategory.create( :description => "Utenti" ){ |c| c.id = 5 }.save


NotificationType.create( :description => "Nuovi contributi e suggerimenti alle proposte a cui partecipo", :notification_category_id => 1 ){ |c| c.id = 1 }.save
NotificationType.create( :description => "Aggiornamento del testo di una proposta a cui partecipo", :notification_category_id => 1 ){ |c| c.id = 2 }.save
NotificationType.create( :description => "Nuove proposte inserite nello spazio comune", :notification_category_id => 1 ){ |c| c.id = 3 }.save
NotificationType.create( :description => "Cambio di stato di una proposta a cui partecipo", :notification_category_id => 1 ){ |c| c.id = 4 }.save
NotificationType.create( :description => "Nuovi commenti alle mie proposte", :notification_category_id => 1 ){ |c| c.id = 5 }.save
NotificationType.create( :description => "Cambio di stato delle mie proposte", :notification_category_id => 1 ){ |c| c.id = 6 }.save
NotificationType.create( :description => "Nuovo sondaggio inserito", :notification_category_id => 2 ){ |c| c.id = 7 }.save
NotificationType.create( :description => "Nuovi post sulle pagine dei gruppi che seguo", :notification_category_id => 3 ){ |c| c.id = 8 }.save
NotificationType.create( :description => "Nuovi post sulle pagine dei gruppi a cui partecipo", :notification_category_id => 3 ){ |c| c.id = 9 }.save
NotificationType.create( :description => "Nuove proposte interne al gruppo", :notification_category_id => 3 ){ |c| c.id = 10 }.save
NotificationType.create( :description => "Cambio di stato di una proposta di gruppo", :notification_category_id => 3 ){ |c| c.id = 11 }.save
NotificationType.create( :description => "Nuova richiesta di partecipazione", :notification_category_id => 3 ){ |c| c.id = 12 }.save
NotificationType.create( :description => "Nuovi eventi pubblici", :notification_category_id => 4 ){ |c| c.id = 13 }.save
NotificationType.create( :description => "Nuovi eventi dei gruppi a cui partecipo", :notification_category_id => 4 ){ |c| c.id = 14 }.save
NotificationType.create( :description => "Nuovo post di un utente che seguo", :notification_category_id => 5 ){ |c| c.id = 15 }.save
NotificationType.create( :description => "Nuova proposta di utente che seguo", :notification_category_id => 5 ){ |c| c.id = 16 }.save
NotificationType.create( :description => "Nuovo sondaggio di un utente che seguo", :notification_category_id => 5 ){ |c| c.id = 17 }.save
NotificationType.create( :description => "Nuovo commento di un utente che seguo", :notification_category_id => 5 ){ |c| c.id = 18 }.save
NotificationType.create( :description => "Nuovi eventi inseriti dagli utenti che seguo", :notification_category_id => 5 ){ |c| c.id = 19 }.save
NotificationType.create( :description => "Nuova valutazione ad una mia proposta", :notification_category_id => 1 ){ |c| c.id = 20 }.save
NotificationType.create( :description => "Nuova valutazione ad una proposta a cui partecipi", :notification_category_id => 1 ){ |c| c.id = 21 }.save
NotificationType.create( :description => "Utente disponibile a redigere la sintesi di una proposta",:email_subject => "Un utente si è reso disponibile a redigere la sintesi di una proposta", :notification_category_id => 1 ){ |c| c.id = 22 }.save
NotificationType.create( :description => "Accettazione come redattore di una proposta",:email_subject => "Sei stato scelto come redattore di una proposta", :notification_category_id => 1 ){ |c| c.id = 23 }.save
NotificationType.create( :description => "Nuovi redattori per le proposte",:email_subject => "Nuovi redattori per una proposta", :notification_category_id => 1 ){ |c| c.id = 24 }.save


ProposalCategory.create( :parent_proposal_category_id => nil, :description => "Nessuna categoria" ){ |c| c.id = 5 }.save
ProposalCategory.create( :parent_proposal_category_id => nil, :description => "Educazione, Ricerca" ){ |c| c.id = 7 }.save
ProposalCategory.create( :parent_proposal_category_id => nil, :description => "Salute, Igiene" ){ |c| c.id = 8 }.save
ProposalCategory.create( :parent_proposal_category_id => nil, :description => "Informazione, Comunicazione" ){ |c| c.id = 9 }.save
ProposalCategory.create( :parent_proposal_category_id => nil, :description => "Commercio, Finanza, Fisco" ){ |c| c.id = 10 }.save
ProposalCategory.create( :parent_proposal_category_id => nil, :description => "Lavoro e Auto-realizzazione" ){ |c| c.id = 11 }.save
ProposalCategory.create( :parent_proposal_category_id => nil, :description => "Sicurezza e Giustizia" ){ |c| c.id = 12 }.save
ProposalCategory.create( :parent_proposal_category_id => nil, :description => "Mondo, Migrazione" ){ |c| c.id = 13 }.save
ProposalCategory.create( :parent_proposal_category_id => nil, :description => "Minoranze, Handicap" ){ |c| c.id = 14 }.save
ProposalCategory.create( :parent_proposal_category_id => nil, :description => "Etica, Solidarietà, Spiritualità" ){ |c| c.id = 15 }.save
ProposalCategory.create( :parent_proposal_category_id => nil, :description => "Sessualità, Famiglia, Bambini" ){ |c| c.id = 16 }.save
ProposalCategory.create( :parent_proposal_category_id => nil, :description => "Arte e Cultura" ){ |c| c.id = 17 }.save
ProposalCategory.create( :parent_proposal_category_id => nil, :description => "Socialità, Sport, Divertimento" ){ |c| c.id = 18 }.save
ProposalCategory.create( :parent_proposal_category_id => nil, :description => "Organizzazione interna" ){ |c| c.id = 19 }.save
ProposalCategory.create( :parent_proposal_category_id => nil, :description => "Acqua, Cibo, Agricoltura" ){ |c| c.id = 20 }.save
ProposalCategory.create( :parent_proposal_category_id => nil, :description => "Territorio, Natura, Animali" ){ |c| c.id = 21 }.save
ProposalCategory.create( :parent_proposal_category_id => nil, :description => "Urbanistica, Mobilità, Edilizia" ){ |c| c.id = 22 }.save
ProposalCategory.create( :parent_proposal_category_id => nil, :description => "Energia, Clima" ){ |c| c.id = 23 }.save
ProposalCategory.create( :parent_proposal_category_id => nil, :description => "Industria, Materiali e Rifiuti" ){ |c| c.id = 24 }.save
ProposalCategory.create( :parent_proposal_category_id => nil, :description => "Salute, Igiene" ){ |c| c.id = 25 }.save

ProposalState.create( :description => "in valutazione" ){ |c| c.id = 1 }.save
ProposalState.create( :description => "in attesa di data" ){ |c| c.id = 2 }.save
ProposalState.create( :description => "in attesa" ){ |c| c.id = 3 }.save
ProposalState.create( :description => "in votazione" ){ |c| c.id = 4 }.save
ProposalState.create( :description => "respinta" ){ |c| c.id = 5 }.save
ProposalState.create( :description => "approvata" ){ |c| c.id = 6 }.save

RankingType.create( :description => "Positivo" ){ |c| c.id = 1 }.save
RankingType.create( :description => "Neutro" ){ |c| c.id = 2 }.save
RankingType.create( :description => "Negativo" ){ |c| c.id = 3 }.save


Tutorial.create( :action => "show", :controller => "home", :name => "Welcome Tutorial", :description => "Tutorial di benvenuto", :created_at => "2012-03-31 15:27:46", :updated_at => "2012-03-31 15:27:46" ){ |c| c.id = 3 }.save
Tutorial.create( :action => "new", :controller => "proposals", :name => "First Proposal", :description => "Tutorial di spiegazione su come inserire la prima proposta", :created_at => "2012-04-10 20:46:54", :updated_at => "2012-04-10 20:46:54" ){ |c| c.id = 4 }.save
Tutorial.create( :action => "show", :controller => "proposals", :name => "Rank Bar", :description => "Tutorial di spiegazione del funzionamento della ranking bar", :created_at => "2012-04-10 20:46:54", :updated_at => "2012-04-10 20:46:54" ){ |c| c.id = 5 }.save


Step.create( :tutorial_id => 3, :index => 0, :title => "Messaggio di benvenuto", :content => nil, :required => false, :fragment => "welcome", :created_at => "2012-03-31 15:27:46", :updated_at => "2012-03-31 15:27:46" ){ |c| c.id = 2 }.save
Step.create( :tutorial_id => 3, :index => 1, :title => "Confini geografici di interesse", :content => nil, :required => false, :fragment => "interest_borders", :created_at => "2012-03-31 15:27:46", :updated_at => "2012-03-31 15:27:46" ){ |c| c.id = 3 }.save
Step.create( :tutorial_id => 3, :index => 2, :title => "Scegli i gruppi", :content => nil, :required => false, :fragment => "choose_follow", :created_at => "2012-03-31 15:27:46", :updated_at => "2012-03-31 15:27:46" ){ |c| c.id = 4 }.save
Step.create( :tutorial_id => 3, :index => 3, :title => "Prima proposta", :content => nil, :required => false, :fragment => "first_proposal", :created_at => "2012-03-31 15:27:46", :updated_at => "2012-03-31 15:27:46" ){ |c| c.id = 5 }.save
Step.create( :tutorial_id => 3, :index => 4, :title => "Immagine", :content => nil, :required => false, :fragment => "choose_image", :created_at => "2012-03-31 15:27:46", :updated_at => "2012-03-31 15:27:46" ){ |c| c.id = 6 }.save
Step.create( :tutorial_id => 4, :index => 0, :title => "Breve spiegazione", :content => nil, :required => false, :fragment => "proposal_instructions", :created_at => "2012-04-10 20:46:54", :updated_at => "2012-04-10 20:46:54" ){ |c| c.id = 7 }.save
Step.create( :tutorial_id => 5, :index => 0, :title => "Spiegazione Rank Bar", :content => nil, :required => false, :fragment => "rank_bar_explain", :created_at => "2012-04-10 20:46:54", :updated_at => "2012-04-10 20:46:54" ){ |c| c.id = 8 }.save

UserType.create( :description => "Administrator", :short_name => "admin" ){ |c| c.id = 1 }.save
UserType.create( :description => "Moderator", :short_name => "mod" ){ |c| c.id = 2 }.save
UserType.create( :description => "User", :short_name => "user" ){ |c| c.id = 4 }.save
UserType.create( :description => "Authenticated User", :short_name => "authuser" ){ |c| c.id = 3 }.save

Quorum.create(:name => "fast", :percentage => 20, :minutes => 2880, :condition => 'OR', :good_score => 50, :bad_score => 50, :public => true)
Quorum.create(:name => "standard", :percentage => 30, :minutes => 21600, :condition => 'OR', :good_score => 60, :bad_score => 60, :public => true)
Quorum.create(:name => "long", :percentage => 50, :minutes => 86400, :condition => 'AND',:good_score => 60, :bad_score => 60, :public => true)
Quorum.create(:name => "good_score", :percentage => 30, :minutes => 21600, :condition => 'OR',:good_score => 70, :bad_score => 30, :public => true)

PartecipationRole.create(:name => "portavoce", :description => "Portavoce")

VoteType.create( :description => "Favorevole"){ |c| c.id = 1 }.save
VoteType.create( :description => "Neutrale"){ |c| c.id = 2 }.save
VoteType.create( :description => "Contrario"){ |c| c.id = 3 }.save
