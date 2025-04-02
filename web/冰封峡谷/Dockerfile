FROM node:20-bookworm-slim

RUN apt-get update \
    && apt-get install -y nginx tini \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install
COPY src ./src
COPY public ./public

COPY default.conf /etc/nginx/sites-available/default
COPY start.sh /start.sh

ENV FLAG="whuctf{sign_in_web_is_easy}"

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/start.sh"]
