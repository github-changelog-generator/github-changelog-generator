FROM ruby:2.4-alpine3.6

LABEL maintainer "olle.jonsson@gmail.com"

RUN gem install github_changelog_generator

ENV SRC_PATH /usr/local/src/your-app
RUN mkdir -p $SRC_PATH

VOLUME [ "$SRC_PATH" ]
WORKDIR $SRC_PATH

CMD ["--help"]
ENTRYPOINT ["github_changelog_generator"]
