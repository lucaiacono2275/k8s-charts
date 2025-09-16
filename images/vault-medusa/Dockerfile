# 🛠 Stage 1: Build Medusa da sorgente
FROM golang:1.21-alpine AS builder

RUN apk add --no-cache git

WORKDIR /app
RUN git clone https://github.com/jonasvinther/medusa.git . \
 && go build -o medusa .

# 🚀 Stage 2: Final image basata su Vault ufficiale
FROM hashicorp/vault:latest

USER root

# Installa jq e dipendenze minime
RUN apk update && apk add --no-cache jq

# Copia il binario di Medusa dal builder
COPY --from=builder /app/medusa /usr/local/bin/medusa

# Torna all'utente Vault per sicurezza
USER vault
