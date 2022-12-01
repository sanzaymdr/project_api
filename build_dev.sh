#!/bin/bash
#
# This script builds your application containers and bootstraps the database
#

DCD='docker-compose -f dcd.yml'

# Build containers and initialize the app for the first time!
echo "Building the containers..."
$DCD build

echo "Setting up the database..."

echo "Creating database..."
$DCD run web bundle exec rake db:create

echo "Migrating database..."
$DCD run web bundle exec rake db:migrate

echo "Creating some seed data..."
$DCD run web bundle exec rake db:seed

echo "Container build complete..."