FROM alpine

RUN apk --update --no-cache add git bash py3-pip

RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing hub

RUN chmod +x entrypoint.sh

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]