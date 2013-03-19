# Survivable Social Network (SSN)

Installation Notes for the Survivable Social Network Project.  This project consists of two main 
components, described below.

+ Social Networking Engine: [TODO: provide a high-level description]
+ AsteriskPBX:

## Social Network Engine (SNE) Development Environment Setup

### Dependencies
1. VirtualBox (v4.2.6 or newer)
2. Ruby 1.9.3-p385
3. Vagrant Gem

	```
	gem install vagrant
	```

### Setting up the environment
1. Clone the repo and navigate to the social-network-engine folder

	```
	git clone git@github.com:CMU-SSN/SSN.git
	cd social-network-engine
	```	

2. Run bundler and install all of the required gems

	```
	bundle install
	```

3. Download the vagrant VirtualBox image from http://goo.gl/PxXLn (requires Google Apps login) [TODO: host this somewhere public]

4. Add the image to vagrant

	```
	vagrant box add ssn_development [path to image download]
	```

5. Start the vagrant VM

	```
	vagrant up
	```

6. Login to the vagrant VM

	```
	vagrant ssh
	```

7. Start the rails server

	```
	cd /vagrant
	bundle exec rails s
	```

For more vagrant commands, see http://www.vagrantup.com

	
### Shutting down the Vagrant VM

1.  Stop the vagrant VM

	```
	vagrant halt
	```
	
### Deploying to the Production Server

1. Change your directory to social-network-engine

2. Use Capistrano to deploy to the server

	```
	cap deploy:update
	cap deploy:migrate
	cap deploy:restart
	```
