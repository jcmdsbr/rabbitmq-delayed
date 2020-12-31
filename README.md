# Resume from RabbitMQ and Delayed Plugin from github

## RabbitMQ Server

Doc: [RabbitMQ](https://rabbitmq.com) is a [feature rich](https://rabbitmq.com/documentation.html), multi-protocol messaging broker. It supports:

## RabbitMQ Delayed Message Plugin

This plugin adds delayed-messaging (or scheduled-messaging) to
RabbitMQ.

A user can declare an exchange with the type `x-delayed-message` and
then publish messages with the custom header `x-delay` expressing in
milliseconds a delay time for the message. The message will be
delivered to the respective queues after `x-delay` milliseconds.

Doc: [RabbitMQ Delayed Message Plugin](https://github.com/rabbitmq/rabbitmq-delayed-message-exchange)
