# Base image 
FROM ruby:2.2.4

MAINTAINER jeremy.pumphrey@nih.gov

ENV INSTALL_PATH /usr/app
RUN mkdir -p $INSTALL_PATH
WORKDIR $INSTALL_PATH

# Install gems 
COPY Gemfile $INSTALL_PATH/
RUN gem install bundler
RUN bundle install 

COPY . . 
RUN ruby -v; rails -v; bundler -v; gem -v
RUN pwd;ls -alt $INSTALL_PATH

ENV RAILS_ENV test

# Default command 
CMD ["rails", "server", "--binding", "0.0.0.0"]
