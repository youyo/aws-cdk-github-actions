FROM node:16-alpine3.14

RUN apk --update --no-cache add python3 py3-pip jq curl bash git docker sudo && \
    ln -sf /usr/bin/python3 /usr/bin/python && \
    addgroup github && adduser -G github -D github && \
    echo '%github ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/github

COPY --from=golang:alpine /usr/local/go/ /usr/local/go/
ENV PATH="/usr/local/go/bin:${PATH}"

COPY entrypoint.sh /entrypoint.sh

USER github:github

ENTRYPOINT ["/entrypoint.sh"]
