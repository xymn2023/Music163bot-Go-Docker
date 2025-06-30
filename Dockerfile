FROM golang AS builder

WORKDIR /build

ADD . /build

RUN bash build.sh

FROM alpine:3.21 AS runner

RUN apk add --no-cache ca-certificates

WORKDIR /app

COPY --from=builder /build/Music163bot-Go .

CMD [ "./Music163bot-Go" ]
