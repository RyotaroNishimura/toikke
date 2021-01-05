FROM ruby:2.5.1
RUN apt-get update && apt-get install -y \
    build-essential \
    nodejs
WORKDIR /kakeibo
COPY Gemfile Gemfile.lock /kakeibo/
RUN bundle install
