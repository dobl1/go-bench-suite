FROM golang:1.22.1-alpine3.19 as build

ARG VERSION

ENV CGO_ENABLED=0
ENV GOOS=linux
ENV GOARCH=amd64

COPY go.mod ./
RUN apk add --no-cache git && \
    go get -u github.com/dobl1/go-bench-suite && \
    cd /go/src/github.com/dobl1/go-bench-suite && git checkout --force $VERSION && \
    go install -a -ldflags="-s -w" .

FROM alpine:3.19.1

ENV HOST=0.0.0.0
ENV PORT=8081

RUN apk --no-cache add ca-certificates
RUN adduser -D -g bench bench
USER bench

WORKDIR /opt/bench
COPY --from=build /go/bin/go-bench-suite /opt/bench/go-bench-suite
USER bench

#EXPOSE $PORT

CMD ["./go-bench-suite"]
