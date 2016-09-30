# Base image 
FROM alpine:latest

MAINTAINER jeremy.pumphrey@nih.gov

ENV BUILD_PACKAGES bash curl-dev ruby-dev build-base git
ENV RUBY_PACKAGES ruby ruby-io-console ruby-bundler ruby-rdoc ruby-irb

# Update and install all of the required packages.
# At the end, remove the apk cache
RUN apk update && \
    apk upgrade && \
    apk add $BUILD_PACKAGES && \
    apk add $RUBY_PACKAGES && \
    rm -rf /var/cache/apk/*

ENV RAILS_VERSION 4.2.6
RUN gem install rails --version "$RAILS_VERSION"

ENV INSTALL_PATH /usr/app
RUN mkdir -p $INSTALL_PATH
WORKDIR $INSTALL_PATH

# Install gems 
COPY Gemfile* $INSTALL_PATH/
#RUN gem install bundler
RUN bundle install 

COPY . . 
RUN pwd;ls -alt $INSTALL_PATH

# Default command 
CMD ["rails", "server", "--binding", "0.0.0.0"]
