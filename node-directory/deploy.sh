#!/bin/bash

# Display usage
if [ $# -ne 2 ]; then
  echo "USAGE: deploy.sh <path to node-directory> <heroku app name>"
  exit 1
fi

echo "This script deploys your current node-directory files to Heroku."

NODE_DIR=$1
APP_NAME=$2
PWD=`pwd`

# Generate a temp folder
TMP_DIR="/tmp/node-deploy.$$.$RANDOM"

echo "Staging directory: ${TMP_DIR}"

# Make an empty git directory in the temporary folder
echo "Creating git repo in staging directory..."
mkdir $TMP_DIR
cd $TMP_DIR
git init
git add .
git commit -m "Empty dir"
echo "DONE"

# Create the heroku remote
echo "Adding the remote heroku master repo..."
heroku git:remote -a $APP_NAME
echo "DONE"

# Copy the node-directory files here
echo "Copying the files to staging..."
cd ${PWD}
cd ${NODE_DIR}
cp -r * ${TMP_DIR}
cd ${TMP_DIR}
echo "DONE"

# Add all the files to the repo
echo "Commiting changes to the repo..."
git add .
git commit -m "Update from head"
echo "DONE"

# Make a pull to get any changes from Heroku
echo "Pulling any changes from Heroku. Ensure the merge did not fail!..."
git pull heroku master
git add .
git commit -m "After pull"
echo "DONE"

# Push to the server
echo "Deploying to heroku..."
git push heroku master
echo "DONE"

# Remove files
echo "Cleaning up staging..."
rm -rf $TMP_DIR
echo "DONE"
