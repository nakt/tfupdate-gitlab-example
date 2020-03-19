# tfupdate
FROM golang:1.13.3-alpine3.10 AS tfupdate
RUN apk --no-cache add make git
RUN git clone https://github.com/minamijoyo/tfupdate /work
WORKDIR /work
RUN go mod download
COPY . .
RUN make build

# lab
FROM golang:1.13.3-alpine3.10 AS lab
RUN apk --no-cache add make git
RUN git clone https://github.com/zaquestion/lab /work
WORKDIR /work
RUN make build

# runtime
FROM alpine:3.10
RUN apk --no-cache add bash git openssh-client tar gzip ca-certificates
COPY --from=tfupdate /work/bin/tfupdate /usr/local/bin/
COPY --from=lab /work/lab /usr/local/bin/
ENTRYPOINT ["tfupdate"]
