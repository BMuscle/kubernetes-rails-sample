FROM ruby:2.7.2
RUN curl https://deb.nodesource.com/setup_12.x | bash \
	&& curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
	&& echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update -qq \
	&& apt-get install -y libpq-dev nodejs yarn

RUN mkdir /app
WORKDIR /app

COPY Gemfile ./
COPY Gemfile.lock ./
RUN bundle install
COPY package.json ./
COPY yarn.lock ./
RUN yarn install

COPY . .

RUN rails assets:precompile

EXPOSE 3000
CMD ["rails", "s", "-b", "0.0.0.0"]
