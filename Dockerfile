FROM alpine:3.13

RUN apk --update --no-cache add nodejs npm python3 py3-pip jq curl bash git docker go>=1.16 && \
	ln -sf /usr/bin/python3 /usr/bin/python

# Configure Go
ENV GOROOT /usr/lib/go
ENV GOPATH /go
ENV PATH /go/bin:$PATH

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
