FROM alpine:latest

RUN apk update && \
  apk add lm-sensors curl

RUN mkdir /var/tmp/scripts/

COPY bash /var/tmp/scripts/

RUN chmod +x /var/tmp/scripts/check-temperature.sh && \
  chmod +x /var/tmp/scripts/commands/sendMessage.sh

RUN echo "*/5 * * * * /var/tmp/scripts/check-temperature.sh" > /etc/crontabs/root

CMD ["crond", "-f"]
