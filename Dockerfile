FROM ruby:2.4-alpine3.6

LABEL maintainer "ferrari.marco@gmail.com"

ENV GITHUB_CHANGELOG_GENERATOR_VERSION "1.14.3"

RUN gem install github_changelog_generator --version $GITHUB_CHANGELOG_GENERATOR_VERSION

ENV SRC_PATH /usr/local/src/your-app
RUN mkdir -p $SRC_PATH

VOLUME [ "$SRC_PATH" ]
WORKDIR $SRC_PATH

CMD ["--help"]
ENTRYPOINT ["github_changelog_generator"]
