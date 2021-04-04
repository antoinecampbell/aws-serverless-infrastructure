FROM alpine:3.13

RUN apk add --no-cache zip \
    nodejs \
    yarn \
    openjdk11-jre \
    terraform=0.14.4-r0 \
    git

# Install K6
RUN wget -O k6.tar.gz https://github.com/k6io/k6/releases/download/v0.31.1/k6-v0.31.1-linux64.tar.gz \
    && tar -zxvf k6.tar.gz \
    && cp k6-v0.31.1-linux64/k6 /usr/local/bin/ \
    && rm -rf k6*