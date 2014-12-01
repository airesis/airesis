Airesis - Choose to participate
===========================================
[![Build Status](https://travis-ci.org/coorasse/Airesis.svg?branch=staging)](https://travis-ci.org/coorasse/Airesis)
[![Dependency Status](https://gemnasium.com/coorasse/Airesis.svg)](https://gemnasium.com/coorasse/Airesis)

The first web application for edemocracy fully OpenSource and Free


Summary
--------
This innovative tool for participatory democracy put at the center, as the main actor, the citizen and finally allows them to be active in the decisions of their territory .

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



License to use
--------------

This software is released under AGPL .

For the terms of the license can be found in the LICENSE file available within the project.

Anyone install the application and development is required to comply with the terms of the license and to incorporate in the footer of your site the following statement:

Powered by <a href="http://www.airesis.eu"> Airesis - Scegli di partecipare </ a>


Setup and Installation
----------------------

The application installs itself as a RubyOnRails any application .

Download the project

`git clone https://github.com/coorasse/Airesis.git`
`cd airesis`

Install the libraries

`bundle install`

Configure database, application and PayPal

`cp config/database.example.yml config/database.yml`

`cp config/application.example.yml config/application.yml`

`cp config/paypal.example.yml config/paypal.yml`

edit the files and set your custom values    
    
`rake db:setup`

run Airesis

`rails s`

run SOLR

`rake sunspot:solr:run`

run Sidekiq

`sidekiq`


That's it!


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
