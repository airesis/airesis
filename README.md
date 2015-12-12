Airesis - The Social Network for eDemocracy
===========================================
[ ![Codeship Status for coorasse/Airesis](https://codeship.com/projects/3bc16c10-0d16-0133-b925-7aae0ba3591b/status?branch=master)](https://codeship.com/projects/91286)
[![Dependency Status](https://gemnasium.com/coorasse/Airesis.svg)](https://gemnasium.com/coorasse/Airesis)
[![Code Climate](https://codeclimate.com/repos/5552681fe30ba02945000686/badges/2885e98c8c20799e22c8/gpa.svg)](https://codeclimate.com/repos/5552681fe30ba02945000686/feed)

The first open source web application for eDemocracy

Summary
--------
This innovative tool for participatory democracy puts the citizens at the center, as the main actors, and finally allows them to be active in the decisions of their territory.

Users can view their own territory and listen to the voices and messages that come directly from other citizens or groups present.

The groups will be able to get in touch with the citizens, support the proposals and create events in the area.

Everything fully integrated with all major social networks and the ability to communicate through e-mail the proposals.

Users who wish to participate in the activities of groups can also sign up and follow the discussions on the forums.

But what really makes Airesis a platform for edemocracy?
The first thing is a totally innovative mechanism for the construction of proposals, where finally the contributions and the minds of the users will be able to merge and make it possible to write proposals in a shared way .

Airesis allows users to have a better ranking on the basis of how they work and contribute to the proposals but at the same time allows a true comparison on the topics and content while maintaining the anonymity of users during the construction of the proposals.

Each time a user participates in a proposal will be overshadowed his real name, so as to ensure that the discussions will focus on the texts and the value of what is written rather than who wrote it.

A system for evaluating the contributions and proposals totally new will automatically identify the users who write better and those who write worse by allowing them to write and evaluate better within the system.

Finally, an implementation of the method schulze will always hold genuine elections within groups or to choose the best among the proposals.

Absolutely simple and intuitive interface will allow everyone in a short time, to find all the information they want.

author
-----------
Alessandro Rodi ( [ coorasse@gmail.com ] (mailto: coorasse@gmail.com ) )

Contributors
------------------
[ List of Contributors to the project Airesis ] ( http://www.airesis.it/chisiamo )

[ Tecnologie Democratiche Association  ] ( http://www.tecnologiedemocratiche.it )

Reference website
-------
[ http://www.airesis.it ] ( http://www.airesis.it )
[ http://www.airesis.eu ] ( http://www.airesis.eu )
[ http://www.airesis.us ] ( http://www.airesis.us )
[ http://www.airesis.fr ] ( http://www.airesis.fr )
[ http://www.airesis.de ] ( http://www.airesis.de )
[ http://www.airesis.cn ] ( http://www.airesis.cn )
[ http://www.airesis.es ] ( http://www.airesis.es )
[ http://www.airesis.pt ] ( http://www.airesis.pt )


License to use
--------------

This software is released under AGPL .

For the terms of the license can be found in the LICENSE file available within the project.

Anyone which installs the application and is required to comply with the terms of the license and to incorporate in the footer of the website the following statement:

Powered by <a href="http://www.airesis.eu"> Airesis - The Social Network for eDemocracy </ a>


Setup and Installation
----------------------

The application installs itself as any other RubyOnRails application.

Download the project

    git clone https://github.com/coorasse/Airesis.git
    cd airesis

Install the libraries

    bundle install

Configure database, application and PayPal

    cp config/database.example.yml config/database.yml
    cp config/application.example.yml config/application.yml
    cp config/private_pub.example.yml config/private_pub.yml
    cp config/sidekiq.example.yml config/sidekiq.yml
    cp config/sunspot.example.yml config/sunspot.yml

edit the files and set your custom values    
    
    bundle exec rake db:setup

run Airesis

    bundle exec rails s

run SOLR

    bundle exec rake sunspot:solr:run

run Sidekiq

    bundle exec sidekiq


That's it!

If you want to run them all you can use Foreman

    bundle exec foreman start
    
and it will take care of running everything for you.

Mailman
-------

Users can reply into the forum by email. Run

    ruby script/mailman_server.rb
    
in background to receive emails.    

SOLR
----

We strongly suggest to edit solrconfig.xml setting
 
      <autoCommit> 
        <maxTime>500</maxTime>
        <openSearcher>false</openSearcher> 
      </autoCommit>
 
      <autoSoftCommit> 
        <maxTime>500</maxTime>
      </autoSoftCommit>

To generate new collections create another solr subfolder like `solr/new_collection` and in solr.xml add
`<core name="new_collection" instanceDir="." dataDir="new_collection/data"/>`

Data
----

You'll probably need some fake data in your development environment to test stuff.
These scripts are available:

    bundle exec rake airesis:seed:more:public_proposals[number]

Will generate `number` fake proposals in public open space and `number` new users (one for each proposal)

    bundle exec rake airesis:seed:more:votable_proposals[number]

Will generate `number` fake proposals in public open space in vote for the next three days and `number` new users (one for each proposal)

    bundle exec rake airesis:seed:more:clear_proposals

Destroy all the proposals in the database

To generate other fake data look at `spec/factories` folder.

Database
--------

Airesis has been developed and tested using PostgreSQL 9.

It's necessary to have PostgreSQL installed with the hstore extension enabled.

Is also necessary to have Redis in order to execute Sidekiq and all background jobs.


Environment variables
---------------------

GEOSPATIAL_NAME is used to geocode users when they register. Is your username in http://www.geonames.org/.
It is used by https://github.com/panthomakos/timezone to obtain timezone based on latitude and longitude and you don't need it in development.

MAPS_API_KEY is a browser key provided by google to access map services (https://console.developers.google.com)

Internationalization
--------------------

http://wiki.airesis.eu/doku.php?id=en:internationalization

What else should I know? What are we working on right now?
------------------

We are working hard trying to convert Airesis in a modular engine.

We want to take out everything which is related to our installation and make it easier to install.

We are working mainly on the proposals and the layout.

Our main goal is to make it even more simple and usable for everybody!
