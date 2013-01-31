Airesis - Scegli di partecipare
===========================================
La prima web application per l'e-democracy completamente OpenSource e gratuita


Sommario
--------
Questo innovativo strumento per la democrazia partecipata pone al centro, come principale attore, il cittadino e gli permette finalmente di essere attivo nelle decisioni del proprio territorio.

Gli utenti potranno visionare il proprio territorio e ascoltare le voci e le segnalazioni che arrivano direttamente dagli altri cittadini oppure sui gruppi presenti.

I gruppi potranno entrare in contatto con i cittadini, sostenere le proposte e creare eventi nel territorio.

Il tutto interamente integrato con i principali Social Network e con la possibilità di comunicare attraverso email le proposte.

Gli utenti che vorranno partecipare alle attività dei gruppi potranno inoltre iscriversi e seguire le discussioni sui forum.

Ma cos'è presente in Airesis che lo rende realmente una piattaforma per la democrazia partecipata?
La prima cosa è un meccanismo di costruzione delle proposte totalmente innovativo, dove finalmente i contributi e le intelligenze degli utenti potranno confluire permettendo di scrivere proposte in maniera condivisa.

Airesis permette agli utenti di avere un ranking migliore in base a quanto contribuiscono e lavorano alle proposte ma al contempo permette un confronto vero sugli argomenti ed i contenuti mantenendo l'anonimato degli utenti durante la costruzione delle proposte.

Ogni volta che un utente partecipa ad una proposta il suo reale nome sarà offuscato, così da far si che le discussioni si concentrino realmente sui
testi ed il valore di quanto è scritto piuttosto che su chi l'ha scritto.

Un sistema di valutazione dei contributi e delle proposte totalmente nuovo permetterà di identificare automaticamente gli utenti che scrivono meglio e coloro che scrivono peggio permettendo loro di scrivere e valutare maggiormente all'interno del sistema.

Infine un'implementazione del metodo di schulze permetterà sempre di indire elezioni vere all'interno dei gruppi o di scegliere la migliore tra le proposte avanzate.

Un'interfaccia assolutamente semplice ed intuitiva permetterà a tutti, in poco tempo, di trovare tutte le informazioni che desiderano.

Autore
-----------
Rodi Alessandro ([coorasse@gmail.com](mailto:coorasse@gmail.com))

Collaboratori
------------------
[Elenco dei collaboratori al progetto Airesis](http://www.airesis.it/chisiamo)

[Associazione Tecnologie Democratiche](http://www.tecnologiedemocratiche.it)

Sito web di riferimento
-------
[http://www.airesis.it](http://www.airesis.it)

Wikipedia
- 
[http://it.wikipedia.org/wiki/Airesis](http://it.wikipedia.org/wiki/Airesis)

Licenza d'uso
-
Il presente software è rilasciato sotto licenza AGPL. 

Per i termini della licenza si rimanda al file LICENSE disponibile all'interno del progetto.

Chiunque installi e sviluppi l'applicazione è tenuto a rispettare i termini della licenza e ad incorporare nel footer del proprio sito la seguente dicitura:

Powered by <a href="http://www.airesis.it">Airesis - Scegli di partecipare </a>


Configurazione e installazione
- 
L'applicazione si installa come una qualsiasi applicazione RubyOnRails.

Scaricare il progetto 

    git clone https://github.com/coorasse/Airesis.git 
    cd Airesis

Installare le librerie

    bundle install
    
Configurare il database

    vim config/database.yml
    rake db:setup
    
Eseguire Airesis

    rails s

