FROM pulumi/pulumi:latest

# Install Hugo. Pass --build-arg "HUGO_VERSION=0.112.0" to override.
ARG HUGO_VERSION="0.111.0"
RUN wget "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz" -O hugo.tar.gz
RUN tar -zxf hugo.tar.gz -C /usr/bin

# Install Cypress dependencies.
# https://docs.cypress.io/guides/continuous-integration/introduction#Dependencies
RUN apt-get update && apt-get install -y \
    libgtk2.0-0 \
    libgtk-3-0 \
    libgbm-dev \
    libnotify-dev \
    libnss3 \
    libxss1 \
    libasound2\
    libxtst6 \
    xauth \
    xvfb

# Install additional tools.
RUN apt-get install -y \
    jq