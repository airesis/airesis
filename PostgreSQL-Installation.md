*How to install and use PostgreSQL - Ubuntu 16.04?*
Installation

The default repositories of Ubuntu contains the Postgres packages, we can install easily using the packaging apt.

If it's our first time using "apt" in this session, we must refresh our local packet index.
We can install the Postgres package and a "contrib" package that adds some additional functions and utilities.


$ sudo apt-get update
$ sudo apt-get install postgresql postgresql-contrib

Now the software is installed.



*Using PostgreSQL Roles and Databases*
By default, Postgress uses a concept called "roles" that handles identification and authorization. 
These are, in a way, similar to Unix account styles, but Postgres does not distinguish between users and groups and instead prefers to be more flexible with the term "role".

Upon completion of the installation, Postgres is ready to use "ident" identification, which means that it associates Postgres roles with a Unix / Linux system account. 
If the role exists in Postgres, a Unix / Linux username with the same name can be identified as that role.



*Switching to a Postgres Account*
The installation procedure created a user called "postgres" that is associated with the Postgres role by default. 
To use Postgres, you can identify yourself with that account.

Change to the postgres account on your server by typing:

$ sudo -i -u postgres

Now you can access the Postgres console immediately by typing:

$ psql

Now it will be entered and you will have access to interact with the database administration system.

Exit the PostgreSQL console by typing:

postgres=# \q

Now you must exit the "postgres" console to Linux.

$ logout



*Create a New Role*
Currently, we only have the "postgres" role configured within the database. We can create new roles from the command line with the command: "createrole"
If you have logged in as a postgres account, you can create a new user by typing:

postgres@server createuser --interactive

If, instead, you prefer to use "sudo" for each command without changing your normal account, you can write:

$ sudo -u postgres createuser --interactive

The script will ask you for some options and, based on your answers, execute the correct Postgres commands to create a user according to your specifications.

Output
Enter name of role to add: ****name****
Shall the new role be a superuser? (y/n) ***y*** (here you can select accord your requirements)

You can get more information ussing:
$ man createuser



SOURCE: https://www.digitalocean.com/community/tutorials/como-instalar-y-utilizar-postgresql-en-ubuntu-16-04-es

Nahuel I. Cuello