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

Author
-----------
Alessandro Rodi ( [ coorasse@gmail.com ] (mailto: coorasse@gmail.com ) )

Contributors
------------------
[ List of Contributors to the project Airesis ] ( http://www.airesis.it/chisiamo )

[ Tecnologie Democratiche Association  ] ( http://www.tecnologiedemocratiche.it )

Reference website
-------
* [ www.airesis.it ] ( http://www.airesis.it )
* [ www.airesis.eu ] ( http://www.airesis.eu )
* [ www.airesis.us ] ( http://www.airesis.us )
* [ www.airesis.fr ] ( http://www.airesis.fr )
* [ www.airesis.de ] ( http://www.airesis.de )
* [ www.airesis.cn ] ( http://www.airesis.cn )
* [ www.airesis.es ] ( http://www.airesis.es )
* [ www.airesis.pt ] ( http://www.airesis.pt )


License
--------------

This software is released under AGPL .

For the terms of the license can be found in the LICENSE file available within the project.

Anyone which installs the application and is required to comply with the terms of the license and to incorporate in the footer of the website the following statement:

Powered by <a href="http://www.airesis.eu"> Airesis - The Social Network for eDemocracy </a>


Installation and Setup
----------------------
You can install Airesis to run locally on your machine, or if you prefer using [Docker containers](#Docker) for a quick and easy setup.

###Local installation
The application installs itself as any other RubyOnRails application.

####Requirements
* PostgreSQL 9 with the hstore extension enabled.
* Redis in order to execute Sidekiq and all background jobs.
* A JVM installed to run SOLR server, used for searching inside Airesis.

####Tutorial
1. Download the project
```
git clone https://github.com/coorasse/Airesis.git
cd airesis
```
2. Install the libraries
```
bundle install
```
3. Configure the database connection and other application variables (such as PayPal, Google Maps API, etc.), run
```
cp config/database.example.yml config/database.yml
cp config/application.example.yml config/application.yml
```
then edit the `.yml` files and set your custom values
4. Bootstrap the database, populating it with initial data (be advised: it will date some time!)
```    
bundle exec rake db:setup
```
5. Run Airesis
```
bundle exec rails s
```
6. run SOLR
```
bundle exec rake sunspot:solr:run
```
7. run Sidekiq
```
bundle exec sidekiq
```

That's it! Now you have a running installation of Airesis!

####Foreman
If you want to run them all in a single command you can use Foreman
```
bundle exec foreman start
```   
and it will take care of running everything for you.

####Mailman
Users can reply in the forum by email. Run
```
ruby script/mailman_server.rb
```    
in background to receive emails and create forum posts from them.  

###Docker
Docker takes care of all the required dependencies for you, and with it you use a fixed and standard dev environment between all of developers. This eliminate inconsistencies problem that can lead to bugs and other complications in running the application.

####Requirements
* [Docker](https://www.docker.com/)
* [Docker Compose](https://github.com/docker/compose)

###Tutorial
1. Download the project
```
git clone https://github.com/coorasse/Airesis.git
cd airesis
```
2. Create the required Docker containers
```
docker-compose build
```
3. To configure application variables (such as PayPal, Google Maps API, etc.), run
```
cp config/database.example.yml config/database.yml
cp config/application.example.yml config/application.yml
```
then edit the `.yml` files and set your custom values
4. Bootstrap and seed the DB
```
docker-compose run --rm airesis bundle exec rake db:setup
```
5. Run Airesis
```
docker-compose up
```

Seeding more data
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

###Using Docker
You can run all the previous command if you use Docker. Juste prefix them with `docker-compose run --rm airesis` to run them in the airesis container.

Fo instance
```
docker-compose run --rm airesis bundle exec rake airesis:seed:more:public_proposals[number]
```
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
