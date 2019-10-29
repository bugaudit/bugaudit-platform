FROM golang:alpine3.10
LABEL maintainer="shibme"
RUN apk add --no-cache curl wget bash
RUN apk add --no-cache openssh-client
RUN apk add --no-cache git
RUN apk add --no-cache openjdk8
RUN apk add --no-cache maven
RUN apk add --no-cache ruby ruby-io-console ruby-bundler ruby-json
RUN gem install rdoc --no-document
RUN gem install bundler:1.17.1
RUN gem install bundler
RUN gem install brakeman
RUN gem install bundler-audit
RUN apk add --no-cache npm
RUN npm install -g retire
WORKDIR /bugaudit-tools
ADD https://dl.bintray.com/jeremy-long/owasp/dependency-check-5.2.2-release.zip /bugaudit-tools/dependency-check.zip
RUN unzip dependency-check.zip
RUN rm dependency-check.zip
RUN ln -s /bugaudit-tools/dependency-check/bin/dependency-check.sh /bin/dependency-check
RUN go get github.com/securego/gosec/cmd/gosec
RUN ln -s /go/bin/gosec /bin/gosec
WORKDIR /bugaudit-workspace
RUN mkdir /root/.ssh
COPY bugaudit-docker-git-config /root/.ssh/config
RUN chmod 400 /root/.ssh/config
RUN dependency-check -s /tmp/
RUN rm dependency-check-report.html
RUN bundle audit update
RUN retire update
