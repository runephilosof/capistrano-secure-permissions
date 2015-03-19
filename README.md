Capistrano::Secure Permissions
---------------

You should create a user to run the app as. For Phusion Passenger, set the user with PassengerUser and PassengerGroup.
That user should not own the files or have any other access to them.
The deploy user should own the files.

````
set :app_user, 'www-client-app'
set :web_user, 'www-data' # Defaults to 'www-data'
````

The `web_user` is the one serving the static files (what apache, nginx, ... is running as).


Installation
-------

Add this line to your application's Gemfile

````
gem 'capistrano-secure-permissions', :git => 'centic@puppet.centic.dk:repos/centic/capistrano-secure-permissions.git'
````


Usage
-----

Add this line to your application's Capfile

````
require 'capistrano/secure-permissions'
````
