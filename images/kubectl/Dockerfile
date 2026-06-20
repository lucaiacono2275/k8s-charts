FROM alpine:latest

ARG KUBECTL_VERSION=v1.34.9
ARG TARGETARCH=amd64
ARG TARGETOS=linux

RUN apk add --no-cache bash ca-certificates curl jq \
    && case "${TARGETARCH}" in \
        amd64) KUBECTL_ARCH=amd64 ;; \
        arm64) KUBECTL_ARCH=arm64 ;; \
        arm) KUBECTL_ARCH=arm ;; \
        *) echo "Unsupported architecture: ${TARGETARCH}" >&2; exit 1 ;; \
    esac \
    && curl -L -o /usr/local/bin/kubectl "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/${TARGETOS}/${KUBECTL_ARCH}/kubectl" \
    && chmod +x /usr/local/bin/kubectl

