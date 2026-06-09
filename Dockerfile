# Stage 1: Build the Go binary
FROM golang:1.26-bookworm AS builder

WORKDIR /app
COPY go.mod ./
# COPY go.sum ./
RUN go mod download
COPY . .
RUN go build -o /autocv ./cmd/autocv/main.go ./cmd/autocv/config.go

# Stage 2: Final Runtime Image
FROM debian:trixie-slim

# 1. Install dependencies for downloading and SSL
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    xz-utils \
    && rm -rf /var/lib/apt/lists/*

# 2. Install Typst binary directly from GitHub
# We'll use version 0.12.0 as a stable target
ENV TYPST_VERSION=0.12.0
RUN curl -L -o typst.tar.xz "https://github.com/typst/typst/releases/download/v${TYPST_VERSION}/typst-x86_64-unknown-linux-musl.tar.xz" && \
    tar -xJf typst.tar.xz && \
    cp typst-x86_64-unknown-linux-musl/typst /usr/local/bin/typst && \
    rm -rf typst.tar.xz typst-x86_64-unknown-linux-musl

WORKDIR /app

# Copy the binary and assets
COPY --from=builder /autocv .
COPY config/ ./config/
COPY src/ ./src/
COPY template/ ./template/
COPY images/ ./images/

RUN mkdir -p out

ENTRYPOINT ["./autocv"]
