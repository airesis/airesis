*How to install Redis in Ubuntu 16.04*
Redis is a database-management system in memory, based on the storage in hash tables but that can be used as a durable or persistent database which makes it quite interesting.



*Install Redis from the Ubuntu Repositories*
To install Networks in Ubuntu 16.04 from the repositories you only need to update the package list and install this service. You can do it by executing these commands:


$ sudo apt update
$ sudo apt install redis-server

Then it must be configured to start the service when the system is booted

$ sudo systemctl enable redis-server



*Install the latest Redis version from the source code in Ubuntu*
Doing the installation from the source code can have several advantages, one of them is that you can have more control over the configuration of this service.

$ sudo apt-get install build-essential tcl



*Download Redis Stable*
cd /tmp
curl -O http://download.redis.io/redis-stable.tar.gz

Then you just have to unzip the file and access the redis-stable directory

$ tar xzvf redis-stable.tar.gz
$ cd redis-stable

Compile Redis from source files.

$ make

Then you have to do a verification of the configuration made by make. (we recommend only having the terminal running)

$ make test

If everything works well and does not show you any errors then you can install the software like this:

$ sudo make install



*Configure Redis in Ubuntu 16.04*
To configure Redis, you must copy the file redis.conf, for this, first create the directory.

$ sudo mkdir /etc/redis

Now we will copy the mentioned file to this location

$ sudo cp /tmp/redis-stable/redis.conf /etc/redis

Now it is necessary to modify this file, locate the headers that are shown throughout the text and configure the line indicated at the end of each one

$ sudo nano /etc/redis/redis.conf

This is the first block of text that refers to how Redis interacts with the system, as it is an Ubuntu server 16.04 systemd must be indicated as shown in the last line of this block.

# If you run Redis from upstart or systemd, Redis can interact with your
# supervision tree. Options:
#   supervised no      - no supervision interaction
#   supervised upstart - signal upstart by putting Redis into SIGSTOP mode
#   supervised systemd - signal systemd by writing READY=1 to $NOTIFY_SOCKET
#   supervised auto    - detect upstart or systemd method based on
#                        UPSTART_JOB or NOTIFY_SOCKET environment variables
# Note: these supervision methods only signal "process is ready."
#       They do not enable continuous liveness pings back to your supervisor.
supervised systemd

The other block refers to a directory where the database files will be stored. This should not be accessible by other users or from the internet. For this the directory /var/lib/redis has been selected

# The working directory.
#
# The DB will be written inside this directory, with the filename specified
# above using the 'dbfilename' configuration directive.
#
# The Append Only File will also be created inside this directory.
#
# Note that you must specify a directory here, not a file name.
dir /var/lib/redis

Make sure you save the changes when you exit the nano editor.



*Create the unit file of Redis for systemd*
The unit file is used for the init system to manage the Redis process. To create this file you must use the command "nano" to edit this file and when it is saved it will be created. Use this command:

$ sudo nano /etc/systemd/system/redis.service

Within the file you must enter the following text:

[Unit]
Description=Redis In-Memory Data Store
After=network.target

[Service]
User=redis
Group=redis
ExecStart=/usr/local/bin/redis-server /etc/redis/redis.conf
ExecStop=/usr/local/bin/redis-cli shutdown
Restart=always

[Install]
WantedBy=multi-user.target

You must save the changes in this file so that the service can be initialized when the system starts up and can be managed with the command "systemctl".



*Create the Redis user, group and directory*
Now you must create the elements so that you can operate what you have configured, one of those elements is the directory that was configured in the /etc/redis/redis.conf file in the dir variable. You can create that directory with the following command:

$ sudo mkdir /var/lib/redis

The next step is to create a user for redis that does not home directory.

$ sudo adduser --system --group --no-create-home redis

And you must assign permissions and assign the redis user as the owner of the /var/lib/redis directory.

$ sudo chown redis:redis /var/lib/redis
$ sudo chmod 770 /var/lib/redis

Now you can test the service and validate that everything you have configured works.



*Start the Redis service and prove that it works*
To start the redis service on your server you can use the command "systemctl".

$ sudo systemctl start redis

You can verify that it is working by checking the status of the service with the status parameter.

$ sudo systemctl status redis

This command should show you an output similar to this:

*redis.service - Redis In-Memory Data Store
  Loaded: loaded (/etc/systemd/system/redis.service; disabled; vendor preset: enabled)
  Active: active (running) since vie 2016-12-23 10:39:59 CST; 2min 30s ago
Main PID: 11809 (redis-server)
  CGroup: /system.slice/redis.service
          -11809 /usr/local/bin/redis-server 127.0.0.1:6379

To prove that the Redis service is working you can do the following test:

$ redis-cli

And it will open a Redis text interface that you can identify by a promt that looks like this: "127.0.0.1:6379>". There you can create a hash and store it in memory for the test.

127.0.0.1:6379> set test "It's working!"

When requesting the value of the "test" hash you should return the text that was stored in it.

127.0.0.1:6379> get test

When executing the above command at the Redis prompt, you should obtain a text output similar to this one:

127.0.0.1:6379> get test
"It's working!"

If you see the previous text is that Redis is working on your server and installation.

SOURCE: https://www.comoinstalarlinux.com/como-instalar-redis-en-ubuntu-16-04/

Nahuel I. Cuello