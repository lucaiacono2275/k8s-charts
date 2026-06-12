FROM alpine:latest

ARG KUBECTL_VERSION=v1.34.10

RUN apk add --no-cache ca-certificates curl samba-client \
    && curl -L -o /usr/local/bin/kubectl "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
    && chmod +x /usr/local/bin/kubectl \
    && kubectl version --client --short

