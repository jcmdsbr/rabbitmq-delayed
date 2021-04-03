# The RabbitMQ and Delayed Plugin from github :sunglasses:

- Building a docker image from rabbitmq use delayed plugin 

## Give a Star! :star:

If you liked the project, please give a star ;)

## You need some of the fallowing tools :exclamation:

-  Visual Studio Code or another editor

## Description :books:

Doc: [RabbitMQ](https://rabbitmq.com) is a [feature rich](https://rabbitmq.com/documentation.html)

### RabbitMQ Delayed Message Plugin 💡

This plugin adds delayed-messaging (or scheduled-messaging) to
RabbitMQ.

A user can declare an exchange with the type `x-delayed-message` and
then publish messages with the custom header `x-delay` expressing in
milliseconds a delay time for the message. The message will be
delivered to the respective queues after `x-delay` milliseconds.

Doc: [RabbitMQ Delayed Message Plugin](https://github.com/rabbitmq/rabbitmq-delayed-message-exchange)
