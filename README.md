# README

reference link: https://www.youtube.com/watch?v=ZEk0Jp2dThc


commands:

- rails generate devise:install
- rails generate devise User
- psql
    + create database learning_authentications;
- rails db:migrate
- rake db:migrate VERSION=0
- rake db:migrate


**** use gem dotnv ****
- bundle install
- touch .env

**** use gem devise-jwt ****
- bundle install
- rails g model JWTBlacklist
- rake secret