FROM ruby:3.1.2

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev
RUN mkdir /product_api

WORKDIR /product_api

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN bundle install

COPY . /product_api