FROM ruby:2.4
WORKDIR /neo4rj
ADD . /neo4rj/
CMD ruby ./bin/start.rb
