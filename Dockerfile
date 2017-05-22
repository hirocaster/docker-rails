FROM ruby

# https://github.com/docker-library/ruby/blob/master/2.4/onbuild/Dockerfile
RUN bundle config --global frozen 1

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ONBUILD COPY Gemfile /usr/src/app/
ONBUILD COPY Gemfile.lock /usr/src/app/
ONBUILD RUN bundle install

ONBUILD COPY . /usr/src/app



ENV DOCKER 1

RUN apt-get update -qq && apt-get install -y build-essential openssl nodejs npm

RUN npm cache clean && npm install n -g
RUN n stable \
      && ln -sf /usr/local/bin/node /usr/bin/node \
      && ln -sf /usr/local/bin/npm /usr/bin/npm

RUN npm install yarn -g
RUN ln -sf /usr/local/bin/yarn /usr/bin/yarn

RUN apt-get purge -y nodejs npm

ENV ENTRYKIT_VERSION 0.4.0
RUN wget https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && tar -xvzf entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && rm entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && mv entrykit /bin/entrykit \
  && chmod +x /bin/entrykit \
  && entrykit --symlink
