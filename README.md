![Pretty Pictures](http://dexter.io/assets/logo.png)

What is Dexter.io?
------------------
Dexter.io is a simple rails application that is designed to be used to act as a simple file server and redirector.  Since there are so many available \*.io domains, anyone can get a cool domain to host files off of.  Stop promoting other people's brands by using bit.ly, tinyurl, or imgur.  Host them on your own page and promote yourself.


Dexter.io is capable of being run on a personal server.  The code is capable of being hosted at heroku as well, but that requires a redis service, and at the cost of the redis-as-a-service applications you are better off deploying to a personal server.

Deploying to a Personal Server
------------------------------

Redis needs to be running on the machine.  Git clone the repo in the directory you wish to run the rails app, and host it through the method you would host any other rails application on that server.

Configuring the root url
------------------------

The root url can be controller by making a drop with the url of `root`.

New Drops
---------

New drops can be created by going to `/drops/new` and configuring that.

Configuration
-------------

Configuration settings can be made by adjusting the values in `config/application.yml`


