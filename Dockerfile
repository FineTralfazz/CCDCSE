FROM ruby:2.6
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev libxml2-dev libxslt1-dev nodejs npm && npm install -g npm@latest && npm install -g yarn
ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME
ADD Gemfile $APP_HOME
ADD Gemfile.lock $APP_HOME
RUN bundle install
ADD ./ $APP_HOME
RUN RAILS_ENV=production rails assets:precompile