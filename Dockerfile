# Base image 
FROM ruby:2.2.4

MAINTAINER jeremy.pumphrey@nih.gov

ENV INSTALL_PATH /usr/app
RUN mkdir -p $INSTALL_PATH
WORKDIR $INSTALL_PATH

ENV RAILS_VERSION 4.2.6
ENV RAILS_ENV test
RUN gem install rails --version "$RAILS_VERSION"

# Install gems 
COPY Gemfile* .
RUN gem install bundler
RUN bundle install 

COPY . . 
RUN pwd;ls -alt $INSTALL_PATH

# Default command 
CMD ["rails", "server", "--binding", "0.0.0.0"]
