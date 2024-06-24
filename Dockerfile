FROM ruby:3.0.3-slim

MAINTAINER marcelo@formmicro.com.br

WORKDIR /usr/src/app

COPY . .

RUN addgroup --system app && adduser --system --ingroup app app

RUN mkdir -p tmp log && chown app:app tmp log

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       build-essential \
       ghostscript \
       git \
       ruby-dev \
    && gem install bundler:2.4.18 \
    && bundle config --global frozen 0 \
    && bundle install \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 9292

USER app

CMD ["bundle", "exec", "puma", "config.ru"]
