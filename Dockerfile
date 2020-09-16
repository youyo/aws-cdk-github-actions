FROM alpine:3

RUN apk --update --no-cache add nodejs nodejs-npm python3 py3-pip jq curl bash git docker build-base && \
	ln -sf /usr/bin/python3 /usr/bin/python

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
