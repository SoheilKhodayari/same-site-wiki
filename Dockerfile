FROM ruby:2.6

ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

WORKDIR /usr/src/app

COPY index.html Gemfile same-site.gemspec ./
RUN gem install bundler && bundle install

EXPOSE 4000
