# Survivable Social Network (SSN)

Installation Notes for the Survivable Social Network Project.  This project consists of two main 
components, described below.

+ Social Networking Engine: [TODO: provide a high-level description]
+ AsteriskPBX:

## Social Network Engine (SNE) Development Environment Setup

### Dependencies
1. VirtualBox (v4.2.6 or newer)
2. Ruby 1.9.3-p385

### Setting up the environment
+ Clone the repo and navigate to the social-network-engine folder

```
git clone git@github.com:CMU-SSN/SSN.git
cd social-network-engine
```	

+ Run bundler and install all of the required gems

```
bundle install
```

+ Download the vagrant VirtualBox image from http://goo.gl/PxXLn (requires Google Apps login) [TODO: host this somewhere public]

+ Add the image to vagrant

```
vagrant add box [path to image download]
```

+ Start the vagrant VM

```
vagrant up
```

+ Login to the vagrant VM

```
vagrant ssh
```

+ Start the rails server

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
