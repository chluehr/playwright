FROM node:22-bookworm

RUN mkdir /app
WORKDIR /app

RUN yarn add playwright
RUN yarn playwright install
RUN yarn playwright install-deps
RUN npm i -D @playwright/test

WORKDIR /root

# Install architecture dependent AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-$(arch).zip" -o "awscliv2.zip"
RUN apt install -y unzip
RUN unzip awscliv2.zip
RUN ./aws/install

WORKDIR /app

ADD playwright.config.ts /app/playwright.config.ts

ADD playwright.sh /app/playwright.sh

ENTRYPOINT ["./playwright.sh"]

