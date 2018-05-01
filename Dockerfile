FROM ruby:2.4
WORKDIR /neo4rj
ADD . /neo4rj/
EXPOSE 7474
EXPOSE 7687
CMD ruby ./bin/start.rb
