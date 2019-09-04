#################################
# Build the support container
FROM ruby:2.5.3-slim-stretch as base

ENV BUILD_DEPS="build-essential libpq-dev libsqlite3-dev tzdata locales git curl unzip" \
    DEBIAN_FRONTEND="noninteractive" \
    RAILS_ENV="production" \
    LANG="en_US.UTF-8"

RUN useradd -m -U app && \
    su -s /bin/bash -c "mkdir -p /home/app/current" app

RUN apt-get update -qq && \
    apt-get install -y $BUILD_DEPS --no-install-recommends

RUN \
    # Set locale
    dpkg-reconfigure -f noninteractive tzdata && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    echo 'LANG="en_US.UTF-8"'>/etc/default/locale && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

WORKDIR /home/app/current

COPY Gemfile /home/app/current/
COPY Gemfile.lock /home/app/current/

RUN chown -R app:app /home/app/current && \
    su -c "bundle install --jobs 20 --retry 5 --with production --without development:test --path vendor/gems" app && \
    rm -rf vendor/gems/ruby/*/cache/* vendor/gems/ruby/*/bundler/gems/*/.git

#################################
# Build the Application container
FROM ruby:2.5.3-slim-stretch as app

RUN useradd -m -U app && \
    su -s /bin/bash -c "mkdir -p /home/app/current/vendor/gems" app

ENV RUNTIME_DEPS="glib-2.0 libpq5 libsqlite3-0 locales netcat nodejs tzdata" \
    DEBIAN_FRONTEND="noninteractive" \
    RAILS_ENV="production" \
    LANG="en_US.UTF-8"

RUN \
    apt-get update -qq && \
    apt-get install -y curl gnupg2 --no-install-recommends && \
    # Install NodeJS and Yarn package repos
    curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    # Install runtime dependencies
    apt-get update -qq && \
    apt-get install -y $RUNTIME_DEPS --no-install-recommends && \
    # Clean up package cruft
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

RUN \
    # Set locale
    dpkg-reconfigure -f noninteractive tzdata && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    echo 'LANG="en_US.UTF-8"'>/etc/default/locale && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

COPY --from=base /usr/local/bundle /usr/local/bundle
COPY . /home/app/current/

RUN chown -R app:staff /usr/local/bundle && \
    chown -R app:app /home/app/current && \
    mkdir /var/log/puma && chown root:app /var/log/puma && chmod 0775 /var/log/puma && \
    mkdir /var/run/puma && chown root:app /var/run/puma && chmod 0775 /var/run/puma

USER app
WORKDIR /home/app/current

COPY --from=base /home/app/current/vendor/gems/ /home/app/current/vendor/gems/

RUN bundle exec rake assets:precompile SECRET_KEY_BASE=$(ruby -r 'securerandom' -e 'puts SecureRandom.hex(64)')

EXPOSE 3000
CMD ["bin/wait-for-it", "db:5432", "--", "bin/boot_container"]
HEALTHCHECK --start-period=60s CMD curl -f http://localhost:3000/
