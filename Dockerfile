FROM ruby:2.7.2-alpine

RUN apk update && apk add --no-cache bash build-base libxml2 libxslt postgresql-libs tzdata libxslt-dev postgresql-dev

WORKDIR /opt/app

COPY Gemfi* ./

RUN gem install bundler -v '2.2.20' && bundle install

RUN mkdir -p tmp/pids tmp/cache

ENTRYPOINT ["bundle", "exec"]

CMD ["rails", "server", "-b", "0.0.0.0"]
