FROM ruby:2.3
ENV TZ Europe/Oslo
RUN apt-get update && apt-get install --assume-yes nodejs
RUN mkdir -p /opt/hunnor-dict/admin-rails
COPY . /opt/hunnor-dict/admin-rails
WORKDIR /opt/hunnor-dict/admin-rails
RUN bundle install
EXPOSE 3000
ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES true
RUN bundle exec rake assets:precompile
ENTRYPOINT ["rails", "server", "--binding=0.0.0.0"]
