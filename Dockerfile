FROM ruby:3.2

RUN apt-get update
RUN apt-get install -y --no-install-recommends postgresql-client
RUN apt-get install -y --no-install-recommends nodejs

ENV BUNDLE_PATH=/bundle \
    BUNDLE_BIN=/bundle/bin \
    GEM_HOME=/bundle
WORKDIR /app
COPY Gemfile ./app/
COPY tramway.gemspec ./app/
ENV PATH="${BUNDLE_BIN}:${PATH}"
ENTRYPOINT ["/usr/src/app/docker-entrypoint.sh"]
