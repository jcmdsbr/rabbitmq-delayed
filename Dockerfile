FROM alpine:20200626 AS base
RUN apk update && apk add --no-cache curl unzip
RUN curl https://dl.bintray.com/rabbitmq/community-plugins/3.7.x/rabbitmq_delayed_message_exchange/rabbitmq_delayed_message_exchange-20171201-3.7.x.zip > /opt/rabbitmq_delayed_message_exchange-20171201-3.7.x.zip
RUN unzip /opt/rabbitmq_delayed_message_exchange-20171201-3.7.x.zip -d /opt

FROM rabbitmq:3.7-management-alpine AS prod
COPY --from=base /opt/rabbitmq_delayed_message_exchange-20171201-3.7.x.ez $RABBITMQ_HOME/plugins/rabbitmq_delayed_message_exchange-20171201-3.7.x.ez
RUN rabbitmq-plugins enable --offline rabbitmq_delayed_message_exchange
RUN rabbitmq-plugins enable --offline rabbitmq_consistent_hash_exchange