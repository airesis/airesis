#encoding: utf-8
class TranslateSomethingElse < ActiveRecord::Migration
  def up
    NotificationCategory.create_translation_table!({
      description: :string
    },
    {migrate_data: true})

    I18n.locale = :eu

    NotificationCategory.find_by_short("MYPROP").update_attribute(:description,"Proposals I write")
    NotificationCategory.find_by_short("PROP").update_attribute(:description,"Proposals I take part")
    NotificationCategory.find_by_short("NEWPROP").update_attribute(:description,"New proposals")
    NotificationCategory.find_by_short("NEWEVENT").update_attribute(:description,"New events")
    NotificationCategory.find_by_short("GROUPS").update_attribute(:description,"Groups")

    I18n.locale = :us

    NotificationCategory.find_by_short("MYPROP").update_attribute(:description,"Proposals I write")
    NotificationCategory.find_by_short("PROP").update_attribute(:description,"Proposals I take part")
    NotificationCategory.find_by_short("NEWPROP").update_attribute(:description,"New proposals")
    NotificationCategory.find_by_short("NEWEVENT").update_attribute(:description,"New events")
    NotificationCategory.find_by_short("GROUPS").update_attribute(:description,"Groups")

    I18n.locale = :en

    NotificationCategory.find_by_short("MYPROP").update_attribute(:description,"Proposals I write")
    NotificationCategory.find_by_short("PROP").update_attribute(:description,"Proposals I take part")
    NotificationCategory.find_by_short("NEWPROP").update_attribute(:description,"New proposals")
    NotificationCategory.find_by_short("NEWEVENT").update_attribute(:description,"New events")
    NotificationCategory.find_by_short("GROUPS").update_attribute(:description,"Groups")

    NotificationType.create_translation_table!({
         description: :string,
         email_subject: :string
     },
     {migrate_data: true})

    I18n.locale = :eu

    NotificationType.find_by_id(1).update_attributes({description: "New contributions and ideas to proposals I am involved in",email_subject: "New comment to proposal"})
    NotificationType.find_by_id(2).update_attributes({description: "Text update about a proposal I am involved in",email_subject: "The proposal has been updated"})
    NotificationType.find_by_id(3).update_attributes({description: "There are new proposals in the common space",email_subject: "There is a new proposal"})
    NotificationType.find_by_id(4).update_attributes({description: "The status of a proposal I am involved in has been changed",email_subject: "The status of the proposal has been changed"})
    NotificationType.find_by_id(5).update_attributes({description: "There are new comments to my proposals",email_subject: "There are new comments to a proposal"})
    NotificationType.find_by_id(6).update_attributes({description: "The status of my proposals has changed",email_subject: "The status of one of your proposals has changed"})
    NotificationType.find_by_id(8).update_attributes({description: "There are new posts in the pages of the groups I am following",email_subject: "There is a new post"})
    NotificationType.find_by_id(9).update_attributes({description: "There are new posts in the pages of the groups I am involved in",email_subject: "There is a new post"})
    NotificationType.find_by_id(10).update_attributes({description: "New proposals within the group",email_subject: "There is a new proposal"})
    NotificationType.find_by_id(12).update_attributes({description: "There is a new participation request",email_subject: "There is a new participation request"})
    NotificationType.find_by_id(13).update_attributes({description: "There are new public events",email_subject: "There is a new public event"})
    NotificationType.find_by_id(14).update_attributes({description: "There is a new event within a group I am involved in",email_subject: "There is a new event"})
    NotificationType.find_by_id(15).update_attributes({description: "There is a new post from a user I am following",email_subject: "There is a new post"})
    NotificationType.find_by_id(20).update_attributes({description: "There is a new evaluation for a proposal of mine",email_subject: "There is a new evaluation for a proposal of yours"})
    NotificationType.find_by_id(21).update_attributes({description: "There is a new evaluation for a proposal I am involved in",email_subject: "There is a new evaluation for a proposal of mine"})
    NotificationType.find_by_id(22).update_attributes({description: "User available to do a summary for a proposal",email_subject: "There is a user available to do a summary of a proposal"})
    NotificationType.find_by_id(23).update_attributes({description: "Acceptance as editor of a proposal",email_subject: "You have been chosen as editor of a proposal"})
    NotificationType.find_by_id(24).update_attributes({description: "New editors for proposals",email_subject: "New editors for a proposal"})

    I18n.locale = :us

    NotificationType.find_by_id(1).update_attributes({description: "New contributions and ideas to proposals I am involved in",email_subject: "New comment to proposal"})
    NotificationType.find_by_id(2).update_attributes({description: "Text update about a proposal I am involved in",email_subject: "The proposal has been updated"})
    NotificationType.find_by_id(3).update_attributes({description: "There are new proposals in the common space",email_subject: "There is a new proposal"})
    NotificationType.find_by_id(4).update_attributes({description: "The status of a proposal I am involved in has been changed",email_subject: "The status of the proposal has been changed"})
    NotificationType.find_by_id(5).update_attributes({description: "There are new comments to my proposals",email_subject: "There are new comments to a proposal"})
    NotificationType.find_by_id(6).update_attributes({description: "The status of my proposals has changed",email_subject: "The status of one of your proposals has changed"})
    NotificationType.find_by_id(8).update_attributes({description: "There are new posts in the pages of the groups I am following",email_subject: "There is a new post"})
    NotificationType.find_by_id(9).update_attributes({description: "There are new posts in the pages of the groups I am involved in",email_subject: "There is a new post"})
    NotificationType.find_by_id(10).update_attributes({description: "New proposals within the group",email_subject: "There is a new proposal"})
    NotificationType.find_by_id(12).update_attributes({description: "There is a new participation request",email_subject: "There is a new participation request"})
    NotificationType.find_by_id(13).update_attributes({description: "There are new public events",email_subject: "There is a new public event"})
    NotificationType.find_by_id(14).update_attributes({description: "There is a new event within a group I am involved in",email_subject: "There is a new event"})
    NotificationType.find_by_id(15).update_attributes({description: "There is a new post from a user I am following",email_subject: "There is a new post"})
    NotificationType.find_by_id(20).update_attributes({description: "There is a new evaluation for a proposal of mine",email_subject: "There is a new evaluation for a proposal of yours"})
    NotificationType.find_by_id(21).update_attributes({description: "There is a new evaluation for a proposal I am involved in",email_subject: "There is a new evaluation for a proposal of mine"})
    NotificationType.find_by_id(22).update_attributes({description: "User available to do a summary for a proposal",email_subject: "There is a user available to do a summary of a proposal"})
    NotificationType.find_by_id(23).update_attributes({description: "Acceptance as editor of a proposal",email_subject: "You have been chosen as editor of a proposal"})
    NotificationType.find_by_id(24).update_attributes({description: "New editors for proposals",email_subject: "New editors for a proposal"})

    I18n.locale = :en

    NotificationType.find_by_id(1).update_attributes({description: "New contributions and ideas to proposals I am involved in",email_subject: "New comment to proposal"})
    NotificationType.find_by_id(2).update_attributes({description: "Text update about a proposal I am involved in",email_subject: "The proposal has been updated"})
    NotificationType.find_by_id(3).update_attributes({description: "There are new proposals in the common space",email_subject: "There is a new proposal"})
    NotificationType.find_by_id(4).update_attributes({description: "The status of a proposal I am involved in has been changed",email_subject: "The status of the proposal has been changed"})
    NotificationType.find_by_id(5).update_attributes({description: "There are new comments to my proposals",email_subject: "There are new comments to a proposal"})
    NotificationType.find_by_id(6).update_attributes({description: "The status of my proposals has changed",email_subject: "The status of one of your proposals has changed"})
    NotificationType.find_by_id(8).update_attributes({description: "There are new posts in the pages of the groups I am following",email_subject: "There is a new post"})
    NotificationType.find_by_id(9).update_attributes({description: "There are new posts in the pages of the groups I am involved in",email_subject: "There is a new post"})
    NotificationType.find_by_id(10).update_attributes({description: "New proposals within the group",email_subject: "There is a new proposal"})
    NotificationType.find_by_id(12).update_attributes({description: "There is a new participation request",email_subject: "There is a new participation request"})
    NotificationType.find_by_id(13).update_attributes({description: "There are new public events",email_subject: "There is a new public event"})
    NotificationType.find_by_id(14).update_attributes({description: "There is a new event within a group I am involved in",email_subject: "There is a new event"})
    NotificationType.find_by_id(15).update_attributes({description: "There is a new post from a user I am following",email_subject: "There is a new post"})
    NotificationType.find_by_id(20).update_attributes({description: "There is a new evaluation for a proposal of mine",email_subject: "There is a new evaluation for a proposal of yours"})
    NotificationType.find_by_id(21).update_attributes({description: "There is a new evaluation for a proposal I am involved in",email_subject: "There is a new evaluation for a proposal of mine"})
    NotificationType.find_by_id(22).update_attributes({description: "User available to do a summary for a proposal",email_subject: "There is a user available to do a summary of a proposal"})
    NotificationType.find_by_id(23).update_attributes({description: "Acceptance as editor of a proposal",email_subject: "You have been chosen as editor of a proposal"})
    NotificationType.find_by_id(24).update_attributes({description: "New editors for proposals",email_subject: "New editors for a proposal"})

    I18n.locale = :de

    NotificationType.find_by_id(1).update_attributes({description: "Neue Beiträge und Ideen zu einem Vorschlag in den ich involviert bin.",email_subject: "Neuer Beitrag zu einem Vorschlag!"})
    NotificationType.find_by_id(2).update_attributes({description: "Textaktualisierung zu einem Vorschlag in den ich involviert bin",email_subject: "Der Vorschlag wurde aktualisiert."})
    NotificationType.find_by_id(3).update_attributes({description: "Es befinden sich neue Vorschläge im Freiraum.",email_subject: "Neuer Vorschlag vorhanden."})
    NotificationType.find_by_id(4).update_attributes({description: "Der Status eines Vorschlags in den ich involviert bin hat sich geändert.",email_subject: "Der Status des Vorschlags wurde verändert."})
    NotificationType.find_by_id(5).update_attributes({description: "Es gibt neue Beiträge zu meinem Vorschlag.",email_subject: "Es gibt neue Beiträge zu einem Vorschlag."})
    NotificationType.find_by_id(6).update_attributes({description: "Der Status meines Vorschlags hat sich geändert.",email_subject: "Der Status eines Deiner Vorschläge hat sich geändert."})
    NotificationType.find_by_id(8).update_attributes({description: "Es gibt eine neues Posting auf der Seite der Gruppen denen ich folge.",email_subject: "Es gibt ein neues Posting."})
    NotificationType.find_by_id(9).update_attributes({description: "Es gibt neue Postings auf den Seiten der Gruppen in denen ich involviert bin.",email_subject: "Es gibt neue Postings."})
    NotificationType.find_by_id(10).update_attributes({description: "Neue Vorschläge in der Gruppe.",email_subject: "Es gibt einen neuen Vorschlag."})
    NotificationType.find_by_id(12).update_attributes({description: "Es gibt eine neue Teilnahme-Anfrage.",email_subject: "Es gibt eine neue Teilnahme-Anfrage."})
    NotificationType.find_by_id(13).update_attributes({description: "Es gibt eine neue öffentliche Veranstaltung.",email_subject: "Es gibt eine neue öffentliche Veranstaltung."})
    NotificationType.find_by_id(14).update_attributes({description: "Es gibt eine neue Veranstaltung in einer Gruppe in die ich involviert bin.",email_subject: "Es gibt eine neue Veranstaltung."})
    NotificationType.find_by_id(15).update_attributes({description: "Es gibt ein neues Posting eines Benutzers dem ich folge.",email_subject: "Es gibt ein neues Posting."})
    NotificationType.find_by_id(20).update_attributes({description: "Es gibt eine neue Bewertung für einen meiner Vorschläge.",email_subject: "Es gibt einen neue Bewertung für einen Deiner Vorschläge."})
    NotificationType.find_by_id(21).update_attributes({description: "Es gibt eine neue Bewertung für einen Vorschlag in den ich involviert bin.",email_subject: "Es gibt eine neue Bewertung für einen Deiner Vorschläge."})
    NotificationType.find_by_id(22).update_attributes({description: "Benutzer verfügbar für eine Zusammenfassung eines Vorschlags.",email_subject: "Benutzer verfügbar für eine Zusammenfassung eines Vorschlags."})
    NotificationType.find_by_id(23).update_attributes({description: "Akzeptanz als Redakteur eines Vorschlags",email_subject: "Du wurdest als Redakteur eines Vorschlags ausgesucht."})
    NotificationType.find_by_id(24).update_attributes({description: "Neue Redakteure für Vorschläge.",email_subject: "Neue Redakteure für Vorschläge."})

    I18n.locale = :fr

    NotificationType.find_by_id(1).update_attributes({description: "Nouvelles contributions et suggestions pour les propositions auxquelles je participe ",email_subject: "Nouveau commentaire à une proposition"})
    NotificationType.find_by_id(2).update_attributes({description: "Mise à jour du texte d'une proposition à laquelle je participe",email_subject: "Une proposition a été mise à jour"})
    NotificationType.find_by_id(3).update_attributes({description: "Nouvelles propositions insérées dans l'espace commun",email_subject: "Une nouvelle proposition a été insérée"})
    NotificationType.find_by_id(4).update_attributes({description: "Changement de statut d'une proposition à laquelle je participe",email_subject: "Une proposition a changé de statut"})
    NotificationType.find_by_id(5).update_attributes({description: "Nouveaux commentaires à mes propositions",email_subject: "Nouveaux commentaires à une proposition"})
    NotificationType.find_by_id(6).update_attributes({description: "Changement de statut de mes propositions",email_subject: "L'une de tes propositions a changé de statut"})
    NotificationType.find_by_id(8).update_attributes({description: "Nouveaux commentaires dans les pages des groupes que je suis",email_subject: "Il y a un nouveau billet"})
    NotificationType.find_by_id(9).update_attributes({description: "Nouveaux commentaires dans les pages des groupes auxquels je participe",email_subject: "il y a un nouveau billet"})
    NotificationType.find_by_id(10).update_attributes({description: "Nouvelles propositions du groupe",email_subject: "Une nouvelle proposition a été insérée"})
    NotificationType.find_by_id(12).update_attributes({description: "Nouvelle demande de participation",email_subject: "Nouvelle demande de participation"})
    NotificationType.find_by_id(13).update_attributes({description: "Nouveaux évenements publiques",email_subject: "Un nouvel évenement a été inséré"})
    NotificationType.find_by_id(14).update_attributes({description: "Nouveaux évenements des groupes auxquels je participe",email_subject: "Un nouvel évenement a été inséré"})
    NotificationType.find_by_id(15).update_attributes({description: "Nouveau billet d'un utilisateur que je suis",email_subject: "Un nouveau billet a été inséré"})
    NotificationType.find_by_id(20).update_attributes({description: "Nouvelle évaluation à l'une de mes propositions",email_subject: "Novelle évaluation à l'une de tes propositions"})
    NotificationType.find_by_id(21).update_attributes({description: "Nouvelle évaluation à une proposition à laquelle je participe",email_subject: "Nouvelle évaluation à une proposition"})
    NotificationType.find_by_id(22).update_attributes({description: "Utilisateur disponible à rédiger la synthèse d'une proposition",email_subject: "Un utilisateur est disponible à rédiger la synthèse d'une proposition"})
    NotificationType.find_by_id(23).update_attributes({description: "Acceptation en tant que rédacteur d'une proposition",email_subject: "Tu as été choisi en tant que rédacteur d'une proposition"})
    NotificationType.find_by_id(24).update_attributes({description: "Nouveaux rédacteurs de propositions",email_subject: "Nouveaux rédacteurs pour une proposition "})

    I18n.locale = :es

    NotificationType.find_by_id(1).update_attributes({description: "Nuevas ideas y sugerencias a las propuestas en la que estoy involucrado.",email_subject: "Nuevo comentario en una propuesta!"})
    NotificationType.find_by_id(2).update_attributes({description: "Actualización de texto de una propuesta en la que estoy involucrado",email_subject: "La propuesta se ha actualizado."})
    NotificationType.find_by_id(3).update_attributes({description: "Hay nuevas propuestas en el espacio comun.",email_subject: "Nueva propuesta disponible."})
    NotificationType.find_by_id(4).update_attributes({description: "El estado de una propuesta en la que estoy involucrado ha cambiado.",email_subject: "El estado de la propuesta se ha modificado."})
    NotificationType.find_by_id(5).update_attributes({description: "Hay nuevos comentarios a mis propuestas.",email_subject: "Nuevos comentarios a mi propuesta."})
    NotificationType.find_by_id(6).update_attributes({description: "El estado de mi propuesta ha cambiado.",email_subject: "El estado de una de sus propuestas ha cambiado."})
    NotificationType.find_by_id(8).update_attributes({description: "Hay nuevos comenatrios en las paginas de los grupos que sigo.",email_subject: "Hay un nuevo comentario."})
    NotificationType.find_by_id(9).update_attributes({description: "Hay nuevos comenatrios en las paginas de los grupos de que participo.",email_subject: "Hay un nuevo comentario."})
    NotificationType.find_by_id(10).update_attributes({description: "Nuevas propuestas en el grupo.",email_subject: "Hay una nueva propuesta."})
    NotificationType.find_by_id(12).update_attributes({description: "Hay una nueva solicitud de partecipación.",email_subject: "Hay una nueva solicitud de partecipación."})
    NotificationType.find_by_id(13).update_attributes({description: "Nuevos eventos publicos",email_subject: "Un nuevo evento se ha añadido"})
    NotificationType.find_by_id(14).update_attributes({description: "Hay un nuevo evento en un grupo en el que estoy involucrado.",email_subject: "Hay un nuevo evento."})
    NotificationType.find_by_id(15).update_attributes({description: "Hay un nuevo posting de un usuario que sigo.",email_subject: "Hay un nuevo posting."})
    NotificationType.find_by_id(20).update_attributes({description: "Una nueva evaluación a mi propuesta. ",email_subject: "Nueva evaluación a tu propuesta."})
    NotificationType.find_by_id(21).update_attributes({description: "Hay una nueva evaluación de una propuesta en la que estoy involucrado.",email_subject: "Nueva evaluación a una propuesta."})
    NotificationType.find_by_id(22).update_attributes({description: "Usuario disponible para un resumen de una propuesta.",email_subject: "Un usuario ha puesto a disposición de redactar el resumen de la propuesta"})
    NotificationType.find_by_id(23).update_attributes({description: "Aceptación como editor de una propuesta",email_subject: "Usted ha sido seleccionado como editor de una propuesta"})
    NotificationType.find_by_id(24).update_attributes({description: "Nuevos editores de propuestas",email_subject: "Nuevos editores por una propuesta."})

    GroupAction.create_translation_table!({
         description: :string
     },
     {migrate_data: true})

    I18n.locale = :eu

    GroupAction.find_by_name("STREAM_POST").update_attributes({description: "Post on the group home page"})
    GroupAction.find_by_name("CREATE_EVENT").update_attributes({description: "Create events and voting"})
    GroupAction.find_by_name("PROPOSAL").update_attributes({description: "Support proposals on behalf of the group"})
    GroupAction.find_by_name("REQUEST_ACCEPT").update_attributes({description: "Add new members to the group"})
    GroupAction.find_by_name("SEND_CANDIDATES").update_attributes({description: "Nominate members for election"})
    GroupAction.find_by_name("PROPOSAL_VIEW").update_attributes({description: "View private proposals"})
    GroupAction.find_by_name("PROPOSAL_PARTICIPATION").update_attributes({description: "Contribute to proposals"})
    GroupAction.find_by_name("PROPOSAL_INSERT").update_attributes({description: "Insert new proposals into the group"})
    GroupAction.find_by_name("DOCUMENT_VIEW").update_attributes({description: "View documents"})
    GroupAction.find_by_name("DOCUMENT_MANAGE").update_attributes({description: "Manage documents"})
    GroupAction.find_by_name("PROPOSAL_VOTE").update_attributes({description: "Vote proposals"})

    I18n.locale = :en

    GroupAction.find_by_name("STREAM_POST").update_attributes({description: "Post on the group home page"})
    GroupAction.find_by_name("CREATE_EVENT").update_attributes({description: "Create events and voting"})
    GroupAction.find_by_name("PROPOSAL").update_attributes({description: "Support proposals on behalf of the group"})
    GroupAction.find_by_name("REQUEST_ACCEPT").update_attributes({description: "Add new members to the group"})
    GroupAction.find_by_name("SEND_CANDIDATES").update_attributes({description: "Nominate members for election"})
    GroupAction.find_by_name("PROPOSAL_VIEW").update_attributes({description: "View private proposals"})
    GroupAction.find_by_name("PROPOSAL_PARTICIPATION").update_attributes({description: "Contribute to proposals"})
    GroupAction.find_by_name("PROPOSAL_INSERT").update_attributes({description: "Insert new proposals into the group"})
    GroupAction.find_by_name("DOCUMENT_VIEW").update_attributes({description: "View documents"})
    GroupAction.find_by_name("DOCUMENT_MANAGE").update_attributes({description: "Manage documents"})
    GroupAction.find_by_name("PROPOSAL_VOTE").update_attributes({description: "Vote proposals"})

    I18n.locale = :us

    GroupAction.find_by_name("STREAM_POST").update_attributes({description: "Post on the group home page"})
    GroupAction.find_by_name("CREATE_EVENT").update_attributes({description: "Create events and voting"})
    GroupAction.find_by_name("PROPOSAL").update_attributes({description: "Support proposals on behalf of the group"})
    GroupAction.find_by_name("REQUEST_ACCEPT").update_attributes({description: "Add new members to the group"})
    GroupAction.find_by_name("SEND_CANDIDATES").update_attributes({description: "Nominate members for election"})
    GroupAction.find_by_name("PROPOSAL_VIEW").update_attributes({description: "View private proposals"})
    GroupAction.find_by_name("PROPOSAL_PARTICIPATION").update_attributes({description: "Contribute to proposals"})
    GroupAction.find_by_name("PROPOSAL_INSERT").update_attributes({description: "Insert new proposals into the group"})
    GroupAction.find_by_name("DOCUMENT_VIEW").update_attributes({description: "View documents"})
    GroupAction.find_by_name("DOCUMENT_MANAGE").update_attributes({description: "Manage documents"})
    GroupAction.find_by_name("PROPOSAL_VOTE").update_attributes({description: "Vote proposals"})

    I18n.locale = :pt

    GroupAction.find_by_name("STREAM_POST").update_attributes({description: "Publicar na home page do grupo"})
    GroupAction.find_by_name("CREATE_EVENT").update_attributes({description: "Criar eventos e voto"})
    GroupAction.find_by_name("PROPOSAL").update_attributes({description: "Apoiar propostas em nome do grupo"})
    GroupAction.find_by_name("REQUEST_ACCEPT").update_attributes({description: "Adicionar partecipantes ao grupo"})
    GroupAction.find_by_name("SEND_CANDIDATES").update_attributes({description: "Nomear os membros para a eleição"})
    GroupAction.find_by_name("PROPOSAL_VIEW").update_attributes({description: "Ver propostas privadas"})
    GroupAction.find_by_name("PROPOSAL_PARTICIPATION").update_attributes({description: "Contribuir as propostas"})
    GroupAction.find_by_name("PROPOSAL_INSERT").update_attributes({description: "Inserir novas propostas no grupo"})
    GroupAction.find_by_name("DOCUMENT_VIEW").update_attributes({description: "visualizar os documentos"})
    GroupAction.find_by_name("DOCUMENT_MANAGE").update_attributes({description: "gerir os documentos"})
    GroupAction.find_by_name("PROPOSAL_VOTE").update_attributes({description: "Votação das propostas"})

    I18n.locale = :de

    GroupAction.find_by_name("STREAM_POST").update_attributes({description: "Auf der Internetseite der Gruppe veröffentlichen"})
    GroupAction.find_by_name("CREATE_EVENT").update_attributes({description: "Veranstaltungen und Abstimmungen erstellen"})
    GroupAction.find_by_name("PROPOSAL").update_attributes({description: "Unterstützung der Vorschläge im Namen der Gruppe"})
    GroupAction.find_by_name("REQUEST_ACCEPT").update_attributes({description: "Neue Mitglieder in die Gruppe aufnehmen"})
    GroupAction.find_by_name("SEND_CANDIDATES").update_attributes({description: "Mitglieder für die Wahlen nominieren"})
    GroupAction.find_by_name("PROPOSAL_VIEW").update_attributes({description: "Private Vorschläge anzeigen"})
    GroupAction.find_by_name("PROPOSAL_PARTICIPATION").update_attributes({description: "Zu den Vorschlägen beitragen"})
    GroupAction.find_by_name("PROPOSAL_INSERT").update_attributes({description: "Neue Vorschläge in die Gruppe eintragen"})
    GroupAction.find_by_name("DOCUMENT_VIEW").update_attributes({description: "Dokumente anzeigen"})
    GroupAction.find_by_name("DOCUMENT_MANAGE").update_attributes({description: "Dokumente verwalten"})
    GroupAction.find_by_name("PROPOSAL_VOTE").update_attributes({description: "Abstimmung über die Vorschläge"})

    I18n.locale = :es

    GroupAction.find_by_name("STREAM_POST").update_attributes({description: "Publicar en la página principal del grupo"})
    GroupAction.find_by_name("CREATE_EVENT").update_attributes({description: "Crear eventos y votaciones"})
    GroupAction.find_by_name("PROPOSAL").update_attributes({description: "Apoyar las propuestas en nombre del grupo"})
    GroupAction.find_by_name("REQUEST_ACCEPT").update_attributes({description: "Adición de partecipantes en el grupo"})
    GroupAction.find_by_name("SEND_CANDIDATES").update_attributes({description: "Designar los miembros para su elección"})
    GroupAction.find_by_name("PROPOSAL_VIEW").update_attributes({description: "Ver las propuestas privadas"})
    GroupAction.find_by_name("PROPOSAL_PARTICIPATION").update_attributes({description: "Contribuir a las propuestas"})
    GroupAction.find_by_name("PROPOSAL_INSERT").update_attributes({description: "Inserir nuevas propuestas en el grupo"})
    GroupAction.find_by_name("DOCUMENT_VIEW").update_attributes({description: "Ver documentos"})
    GroupAction.find_by_name("DOCUMENT_MANAGE").update_attributes({description: "Gestionar los documentos"})
    GroupAction.find_by_name("PROPOSAL_VOTE").update_attributes({description: "Votación de las propuestas"})

    I18n.locale = :fr

    GroupAction.find_by_name("STREAM_POST").update_attributes({description: "Publier dans la page d'accueil du groupe"})
    GroupAction.find_by_name("CREATE_EVENT").update_attributes({description: "Créer des événements et des votes"})
    GroupAction.find_by_name("PROPOSAL").update_attributes({description: "Soutenir les propositions au nom du groupe"})
    GroupAction.find_by_name("REQUEST_ACCEPT").update_attributes({description: "Ajouter des nouveaux membres au groupe"})
    GroupAction.find_by_name("SEND_CANDIDATES").update_attributes({description: "Nommer des membres pour l'élection"})
    GroupAction.find_by_name("PROPOSAL_VIEW").update_attributes({description: "Voir les propositions privées"})
    GroupAction.find_by_name("PROPOSAL_PARTICIPATION").update_attributes({description: "Contribuer aux propositions"})
    GroupAction.find_by_name("PROPOSAL_INSERT").update_attributes({description: "Insérer des nouvelles propositions dans le groupe"})
    GroupAction.find_by_name("DOCUMENT_VIEW").update_attributes({description: "voir les documents"})
    GroupAction.find_by_name("DOCUMENT_MANAGE").update_attributes({description: "Gérer les documents"})
    GroupAction.find_by_name("PROPOSAL_VOTE").update_attributes({description: "Vote sur les propositions"})

    EventType.create_translation_table!({
        description: :string
    },
    {migrate_data: true})

    I18n.locale = :eu
    EventType.find_by_id(1).update_attributes({description: "meeting"})
    EventType.find_by_id(2).update_attributes({description: "vote"})
    EventType.find_by_id(3).update_attributes({description: "meeting"})
    EventType.find_by_id(4).update_attributes({description: "election"})

    I18n.locale = :en
    EventType.find_by_id(1).update_attributes({description: "meeting"})
    EventType.find_by_id(2).update_attributes({description: "vote"})
    EventType.find_by_id(3).update_attributes({description: "meeting"})
    EventType.find_by_id(4).update_attributes({description: "election"})

    I18n.locale = :us
    EventType.find_by_id(1).update_attributes({description: "meeting"})
    EventType.find_by_id(2).update_attributes({description: "vote"})
    EventType.find_by_id(3).update_attributes({description: "meeting"})
    EventType.find_by_id(4).update_attributes({description: "election"})

    I18n.locale = :pt

    EventType.find_by_id(1).update_attributes({description: "encontro"})
    EventType.find_by_id(2).update_attributes({description: "voto"})
    EventType.find_by_id(3).update_attributes({description: "reunião"})
    EventType.find_by_id(4).update_attributes({description: "eleição"})

    I18n.locale = :de
    EventType.find_by_id(1).update_attributes({description: "Treffen"})
    EventType.find_by_id(2).update_attributes({description: "Abstimmungen"})
    EventType.find_by_id(3).update_attributes({description: "Versammlungen"})
    EventType.find_by_id(4).update_attributes({description: "Wahlen"})

    I18n.locale = :es
    EventType.find_by_id(1).update_attributes({description: "cita"})
    EventType.find_by_id(2).update_attributes({description: "voto"})
    EventType.find_by_id(3).update_attributes({description: "reunión"})
    EventType.find_by_id(4).update_attributes({description: "elección"})

    I18n.locale = :fr
    EventType.find_by_id(1).update_attributes({description: "rendez-vous"})
    EventType.find_by_id(2).update_attributes({description: "vote"})
    EventType.find_by_id(3).update_attributes({description: "réunion"})
    EventType.find_by_id(4).update_attributes({description: "élections"})


    I18n.locale = :pt

    Stato.find_by_sigla('AX').update_attributes({description: "Ilhas Aland"})
    Stato.find_by_sigla('AL').update_attributes({description: "Albânia"})
    Stato.find_by_sigla('AD').update_attributes({description: "Andorra"})
    Stato.find_by_sigla('AT').update_attributes({description: "Áustria"})
    Stato.find_by_sigla('BY').update_attributes({description: "Belarússia"})
    Stato.find_by_sigla('BE').update_attributes({description: "Bélgica"})
    Stato.find_by_sigla('BA').update_attributes({description: "Bósnia Herzegovina"})
    Stato.find_by_sigla('BG').update_attributes({description: "Bulgária"})
    Stato.find_by_sigla('HR').update_attributes({description: "Croácia"})
    Stato.find_by_sigla('CZ').update_attributes({description: "República Checa"})
    Stato.find_by_sigla('DK').update_attributes({description: "Dinamarca"})
    Stato.find_by_sigla('EE').update_attributes({description: "Estónia"})
    Stato.find_by_sigla('FO').update_attributes({description: "Ilhas Faroe"})
    Stato.find_by_sigla('FI').update_attributes({description: "Finlândia"})
    Stato.find_by_sigla('FR').update_attributes({description: "França"})
    Stato.find_by_sigla('DE').update_attributes({description: "Alemanha"})
    Stato.find_by_sigla('GI').update_attributes({description: "Gibraltar"})
    Stato.find_by_sigla('GR').update_attributes({description: "Grécia"})
    Stato.find_by_sigla('GG').update_attributes({description: "Guernsey"})
    Stato.find_by_sigla('HU').update_attributes({description: "Hungria"})
    Stato.find_by_sigla('IS').update_attributes({description: "Islândia"})
    Stato.find_by_sigla('IE').update_attributes({description: "Irlanda"})
    Stato.find_by_sigla('IM').update_attributes({description: "Ilha de Man"})
    Stato.find_by_sigla('IT').update_attributes({description: "Itália"})
    Stato.find_by_sigla('JE').update_attributes({description: "Jersey"})
    Stato.find_by_sigla('XK').update_attributes({description: "Kosovo"})
    Stato.find_by_sigla('LV').update_attributes({description: "Letónia"})
    Stato.find_by_sigla('LI').update_attributes({description: "Liechtenstein"})
    Stato.find_by_sigla('LT').update_attributes({description: "Lituânia"})
    Stato.find_by_sigla('LU').update_attributes({description: "Luxemburgo"})
    Stato.find_by_sigla('MK').update_attributes({description: "Macedónia"})
    Stato.find_by_sigla('MT').update_attributes({description: "Malta"})
    Stato.find_by_sigla('MD').update_attributes({description: "Moldávia"})
    Stato.find_by_sigla('MC').update_attributes({description: "Mónaco"})
    Stato.find_by_sigla('ME').update_attributes({description: "Montenegro"})
    Stato.find_by_sigla('NL').update_attributes({description: "Holanda"})
    Stato.find_by_sigla('NO').update_attributes({description: "Noruega"})
    Stato.find_by_sigla('PL').update_attributes({description: "Polónia"})
    Stato.find_by_sigla('PT').update_attributes({description: "Portugal"})
    Stato.find_by_sigla('RO').update_attributes({description: "Roménia"})
    Stato.find_by_sigla('RU').update_attributes({description: "Federação Russa"})
    Stato.find_by_sigla('SM').update_attributes({description: "San Marino"})
    Stato.find_by_sigla('RS').update_attributes({description: "Sérvia"})
    Stato.find_by_sigla('SK').update_attributes({description: "Eslováquia"})
    Stato.find_by_sigla('SI').update_attributes({description: "Eslovénia"})
    Stato.find_by_sigla('ES').update_attributes({description: "Espanha"})
    Stato.find_by_sigla('SJ').update_attributes({description: "Svalbard e Jan Mayen"})
    Stato.find_by_sigla('SE').update_attributes({description: "Suécia"})
    Stato.find_by_sigla('CH').update_attributes({description: "Suíça"})
    Stato.find_by_sigla('UA').update_attributes({description: "Ucrânia"})
    Stato.find_by_sigla('GB').update_attributes({description: "Reino Unido"})
    Stato.find_by_sigla('VA').update_attributes({description: "Cidade do Vaticano"})

    I18n.locale = :de

    Stato.find_by_sigla('AX').update_attributes({description: "Åland-Inseln"})
    Stato.find_by_sigla('AL').update_attributes({description: " Albanien"})
    Stato.find_by_sigla('AD').update_attributes({description: "Andorra"})
    Stato.find_by_sigla('AT').update_attributes({description: "Österreich"})
    Stato.find_by_sigla('BY').update_attributes({description: "Weissrußland"})
    Stato.find_by_sigla('BE').update_attributes({description: "Belgien"})
    Stato.find_by_sigla('BA').update_attributes({description: "Bosnien und Herzogowina"})
    Stato.find_by_sigla('BG').update_attributes({description: "Bulgarien"})
    Stato.find_by_sigla('HR').update_attributes({description: "Kroatien"})
    Stato.find_by_sigla('CZ').update_attributes({description: "Tschechische Republik"})
    Stato.find_by_sigla('DK').update_attributes({description: "Dänemark"})
    Stato.find_by_sigla('EE').update_attributes({description: "Estland"})
    Stato.find_by_sigla('FO').update_attributes({description: "Faroe Inseln"})
    Stato.find_by_sigla('FI').update_attributes({description: "Finnland"})
    Stato.find_by_sigla('FR').update_attributes({description: "Frankreich"})
    Stato.find_by_sigla('DE').update_attributes({description: "Deutschland"})
    Stato.find_by_sigla('GI').update_attributes({description: "Gibraltar"})
    Stato.find_by_sigla('GR').update_attributes({description: "Griechenland"})
    Stato.find_by_sigla('GG').update_attributes({description: "Guernsey"})
    Stato.find_by_sigla('HU').update_attributes({description: "Ungarn"})
    Stato.find_by_sigla('IS').update_attributes({description: "Island"})
    Stato.find_by_sigla('IE').update_attributes({description: "Irland"})
    Stato.find_by_sigla('IM').update_attributes({description: "Isle of Man"})
    Stato.find_by_sigla('IT').update_attributes({description: "Italien"})
    Stato.find_by_sigla('JE').update_attributes({description: "Jersey"})
    Stato.find_by_sigla('XK').update_attributes({description: "Kosowo"})
    Stato.find_by_sigla('LV').update_attributes({description: "Letland"})
    Stato.find_by_sigla('LI').update_attributes({description: "Liechtenstein"})
    Stato.find_by_sigla('LT').update_attributes({description: "Litauen"})
    Stato.find_by_sigla('LU').update_attributes({description: "Luxemburg"})
    Stato.find_by_sigla('MK').update_attributes({description: "Mazedonien"})
    Stato.find_by_sigla('MT').update_attributes({description: "Malta"})
    Stato.find_by_sigla('MD').update_attributes({description: "Moldawien"})
    Stato.find_by_sigla('MC').update_attributes({description: "Monaco"})
    Stato.find_by_sigla('ME').update_attributes({description: "Montenegro"})
    Stato.find_by_sigla('NL').update_attributes({description: "Holland"})
    Stato.find_by_sigla('NO').update_attributes({description: "Norwegen"})
    Stato.find_by_sigla('PL').update_attributes({description: "Polen"})
    Stato.find_by_sigla('PT').update_attributes({description: "Portugal"})
    Stato.find_by_sigla('RO').update_attributes({description: "Rumänien"})
    Stato.find_by_sigla('RU').update_attributes({description: "Rußland"})
    Stato.find_by_sigla('SM').update_attributes({description: "San Marino"})
    Stato.find_by_sigla('RS').update_attributes({description: "Serbien"})
    Stato.find_by_sigla('SK').update_attributes({description: "Slowakei"})
    Stato.find_by_sigla('SI').update_attributes({description: "Slowenien"})
    Stato.find_by_sigla('ES').update_attributes({description: "Spanien"})
    Stato.find_by_sigla('SJ').update_attributes({description: "Svalbard e Jan Mayen"})
    Stato.find_by_sigla('SE').update_attributes({description: "Schweden"})
    Stato.find_by_sigla('CH').update_attributes({description: "Schweiz"})
    Stato.find_by_sigla('UA').update_attributes({description: "Ukraine"})
    Stato.find_by_sigla('GB').update_attributes({description: "Großbritannien"})
    Stato.find_by_sigla('VA').update_attributes({description: "Vatikan"})

    I18n.locale = :es

    Stato.find_by_sigla('AX').update_attributes({description: "Islas Åland"})
    Stato.find_by_sigla('AL').update_attributes({description: "Albania"})
    Stato.find_by_sigla('AD').update_attributes({description: "Andora"})
    Stato.find_by_sigla('AT').update_attributes({description: "Austria"})
    Stato.find_by_sigla('BY').update_attributes({description: "Bielorusia"})
    Stato.find_by_sigla('BE').update_attributes({description: "Bélgica"})
    Stato.find_by_sigla('BA').update_attributes({description: "Bósnia Herzegovina"})
    Stato.find_by_sigla('BG').update_attributes({description: "Bulgária"})
    Stato.find_by_sigla('HR').update_attributes({description: "Croácia"})
    Stato.find_by_sigla('CZ').update_attributes({description: "República Checa"})
    Stato.find_by_sigla('DK').update_attributes({description: "Dinamarca"})
    Stato.find_by_sigla('EE').update_attributes({description: "Estónia"})
    Stato.find_by_sigla('FO').update_attributes({description: "Islas Faroe"})
    Stato.find_by_sigla('FI').update_attributes({description: "Finlândia"})
    Stato.find_by_sigla('FR').update_attributes({description: "Francia"})
    Stato.find_by_sigla('DE').update_attributes({description: "Alemania"})
    Stato.find_by_sigla('GI').update_attributes({description: "Gibraltar"})
    Stato.find_by_sigla('GR').update_attributes({description: "Grécia"})
    Stato.find_by_sigla('GG').update_attributes({description: "Guernsey"})
    Stato.find_by_sigla('HU').update_attributes({description: "Hungria"})
    Stato.find_by_sigla('IS').update_attributes({description: "Islândia"})
    Stato.find_by_sigla('IE').update_attributes({description: "Irlanda"})
    Stato.find_by_sigla('IM').update_attributes({description: "Isla de Man"})
    Stato.find_by_sigla('IT').update_attributes({description: "Italia"})
    Stato.find_by_sigla('JE').update_attributes({description: "Jersez"})
    Stato.find_by_sigla('XK').update_attributes({description: "Kosovo"})
    Stato.find_by_sigla('LV').update_attributes({description: "Letónia"})
    Stato.find_by_sigla('LI').update_attributes({description: "Liechtenstein"})
    Stato.find_by_sigla('LT').update_attributes({description: "Lituânia"})
    Stato.find_by_sigla('LU').update_attributes({description: "Luxemburgo"})
    Stato.find_by_sigla('MK').update_attributes({description: "Macedónia"})
    Stato.find_by_sigla('MT').update_attributes({description: "Malta"})
    Stato.find_by_sigla('MD').update_attributes({description: "Moldávia"})
    Stato.find_by_sigla('MC').update_attributes({description: "Mónaco"})
    Stato.find_by_sigla('ME').update_attributes({description: "Montenegro"})
    Stato.find_by_sigla('NL').update_attributes({description: "Holanda"})
    Stato.find_by_sigla('NO').update_attributes({description: "Noruega"})
    Stato.find_by_sigla('PL').update_attributes({description: "Polónia"})
    Stato.find_by_sigla('PT').update_attributes({description: "Portugal"})
    Stato.find_by_sigla('RO').update_attributes({description: "Roménia"})
    Stato.find_by_sigla('RU').update_attributes({description: "Federación Rusa"})
    Stato.find_by_sigla('SM').update_attributes({description: "San Marino"})
    Stato.find_by_sigla('RS').update_attributes({description: "Sérbia"})
    Stato.find_by_sigla('SK').update_attributes({description: "Eslovaquia"})
    Stato.find_by_sigla('SI').update_attributes({description: "Eslovénia"})
    Stato.find_by_sigla('ES').update_attributes({description: "España"})
    Stato.find_by_sigla('SJ').update_attributes({description: "Svalbard e Jan Mayen"})
    Stato.find_by_sigla('SE').update_attributes({description: "Suécia"})
    Stato.find_by_sigla('CH').update_attributes({description: "Suiza"})
    Stato.find_by_sigla('UA').update_attributes({description: "Ucrania"})
    Stato.find_by_sigla('GB').update_attributes({description: "Inglaterra"})
    Stato.find_by_sigla('VA').update_attributes({description: "Cuidad del Vaticaon"})

    VoteType.create_translation_table!({
          description: :string
      },
      {migrate_data: true})

    I18n.locale = :en
    VoteType.find_by_id(1).update_attributes({description: "Favorable"})
    VoteType.find_by_id(2).update_attributes({description: "Neutral"})
    VoteType.find_by_id(3).update_attributes({description: "Dissenting"})

    I18n.locale = :eu
    VoteType.find_by_id(1).update_attributes({description: "Favorable"})
    VoteType.find_by_id(2).update_attributes({description: "Neutral"})
    VoteType.find_by_id(3).update_attributes({description: "Dissenting"})

    I18n.locale = :us
    VoteType.find_by_id(1).update_attributes({description: "Favorable"})
    VoteType.find_by_id(2).update_attributes({description: "Neutral"})
    VoteType.find_by_id(3).update_attributes({description: "Dissenting"})

  end

  def down
  end
end
