FROM alpine

RUN apk --update --no-cache add git bash py3-pip git-lfs

RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing hub

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
