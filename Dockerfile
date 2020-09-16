FROM ruby:2.7.1

RUN apt-get update -qq
RUN apt-get install -y nodejs build-essential apt-utils \
     autoconf libc6-dev automake libtool bison pkg-config \
     zlib1g zlib1g-dev curl \
     postgresql postgresql-client postgresql-contrib libpq-dev \
     openssl libssl-dev libcurl4-openssl-dev \
     libyaml-dev libxml2-dev libxslt1-dev
RUN mkdir /ssl_tracker
WORKDIR /ssl_tracker
COPY Gemfile /ssl_tracker/Gemfile
COPY Gemfile.lock /ssl_tracker/Gemfile.lock
RUN gem install bundler
COPY . /ssl_tracker
RUN bundle install