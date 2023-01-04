FROM alpine

RUN apk --update --no-cache add git bash py3-pip

RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing hub

RUN chmod 777 entrypoint.sh

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]