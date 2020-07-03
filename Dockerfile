FROM ruby:2.4.0
RUN apt-get update -qq && apt-get install -y sqlite3 nodejs

ENV RAILS_ROOT /myapp
RUN mkdir $RAILS_ROOT
WORKDIR $RAILS_ROOT

COPY Gemfile $RAILS_ROOT/Gemfile
COPY Gemfile.lock $RAILS_ROOT/Gemfile.lock
RUN gem install bundler -v 1.3.0
RUN bundle _1.3.0_ install
COPY . $RAILS_ROOT

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]

