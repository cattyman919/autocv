FROM alpine:3.23

# 1. Define the exact Go version you want
ENV GOLANG_VERSION=1.26.1

# 2. Install dependencies for downloading and extracting Go, plus Git
RUN apk add --no-cache curl git tar typst gcompat

# 3. Download the specific Go binary and extract it to /usr/local
# (Note: This assumes an amd64 architecture. Change to arm64 if using Apple Silicon/ARM)
RUN curl -L -o go.tar.gz "https://golang.org/dl/go${GOLANG_VERSION}.linux-amd64.tar.gz" && \
    tar -C /usr/local -xzf go.tar.gz && \
    rm go.tar.gz

ENV GOPATH=/go
ENV GOMODCACHE=/go/pkg/mod
ENV GOCACHE=/root/.cache/go-build
ENV PATH=$PATH:/go/bin

WORKDIR /app

COPY go.mod go.sum ./

RUN --mount=type=cache,target=/go/pkg/mod \
    go mod download

COPY . .

ENTRYPOINT ["go", "run", "./cmd/autocv/"]
# ENTRYPOINT ["sh", "-c", "go run main.go"]
