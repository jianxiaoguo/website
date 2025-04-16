FROM registry.drycc.cc/drycc/go-dev

ENV HUGO_REPO=https://github.com/gohugoio/hugo \
  HUGO_VERSION=0.146.5

RUN apt update \
  && apt install -yq npm \
  && curl -s -L ${HUGO_REPO}/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-$(dpkg --print-architecture).tar.gz | tar xvz -C /usr/local/bin hugo

CMD ["bash", "-c", "npm install postcss-cli; hugo"]
