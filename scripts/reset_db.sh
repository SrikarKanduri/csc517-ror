#!/bin/bash

# drop all tables in db and migrate again
rake db:reset

# seed the database with Admin account and fake users
rails db:seed