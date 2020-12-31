# ABOUT RABBITMQ

## RabbitMQ Server

[RabbitMQ](https://rabbitmq.com) is a [feature rich](https://rabbitmq.com/documentation.html), multi-protocol messaging broker. It supports:

- AMQP 0-9-1
- AMQP 1.0
- MQTT 3.1.1
- STOMP 1.0 through 1.2

### Installation

- [Installation guides](https://rabbitmq.com/download.html) for various platforms
- [Kubernetes Cluster Operator](https://www.rabbitmq.com/kubernetes/operator/operator-overview.html)
- [Changelog](https://www.rabbitmq.com/changelog.html)
- [Releases](https://github.com/rabbitmq/rabbitmq-server/releases) on GitHub
- [Supported and unsupported series](https://www.rabbitmq.com/versions.html)
- [Supported Erlang versions](https://www.rabbitmq.com/which-erlang.html)

### Tutorials & Documentation

- [RabbitMQ tutorials](https://rabbitmq.com/getstarted.html)
- [All documentation guides](https://rabbitmq.com/documentation.html)
- [CLI tools guide](https://rabbitmq.com/cli.html) 
- [Configuration guide](https://rabbitmq.com/configure.html) 
- [Client libraries and tools](https://rabbitmq.com/devtools.html)
- [Monitoring guide](https://rabbitmq.com/monitoring.html)
- [Production checklist](https://rabbitmq.com/production-checklist.html)
- [Runnable tutorials](https://github.com/rabbitmq/rabbitmq-tutorials/)
- [Documentation source](https://github.com/rabbitmq/rabbitmq-website/)

### Getting Help

- [RabbitMQ mailing list](https://groups.google.com/forum/#!forum/rabbitmq-users)
- [Commercial support](https://rabbitmq.com/services.html) from [VMware](https://vmware.com) for open source RabbitMQ
- [Community Slack](https://rabbitmq-slack.herokuapp.com/)
- `#rabbitmq` on Freenode

---

## RabbitMQ Delayed Message Plugin

This plugin adds delayed-messaging (or scheduled-messaging) to
RabbitMQ.

A user can declare an exchange with the type `x-delayed-message` and
then publish messages with the custom header `x-delay` expressing in
milliseconds a delay time for the message. The message will be
delivered to the respective queues after `x-delay` milliseconds.

### Project Maturity

This plugin is considered to be **experimental yet fairly stable and potential suitable for production use
as long as the user is aware of its limitations**.

It had a few issues and one fundamental problem fixed in its ~ 18 months of
existence. It is known to work reasonably well for some users.
It also has **known limitations** (see a section below),
including those related to the replication of delayed and messages and the number of delayed messages.

This plugin is not commercially supported by Pivotal at the moment but
it doesn't mean that it will be abandoned or team RabbitMQ is not interested
in improving it in the future. It is not, however, a high priority for our small team.

So, give it a try with your workload and decide for yourself.

### Enabling the Plugin

Then run the following command:

``` bash
rabbitmq-plugins enable rabbitmq_delayed_message_exchange
```

### Routing

This plugin allows for flexible routing via the `x-delayed-type`
arguments that can be passed during `exchange.declare`. In the example
above we used `"direct"` as exchange type. That means the plugin
will have the same routing behavior shown by the direct exchange.

If you want a different routing behavior, then you could provide a
different exchange type, like `"topic"` for example. You can also
specify exchange types provided by plugins. Note that this argument is
**required** and **must** refer to an **existing exchange type**.

### Performance Impact

Due to the `"x-delayed-type"` argument, one could use this exchange in
place of other exchanges, since the `"x-delayed-message"` exchange
will just act as proxy. Note that there might be some performance
implications if you do this.

For each message that crosses an `"x-delayed-message"` exchange, the
plugin will try to determine if the message has to be expired by
making sure the delay is within range, ie: `Delay > 0, Delay =<
?ERL_MAX_T` (In Erlang a timer can be set up to (2^32)-1 milliseconds
in the future).

If the previous condition holds, then the message will be persisted to
Mnesia and some other logic will kick in to determine if this
particular message delay needs to replace the current scheduled timer
and so on.

This means that while one _could_ use this exchange in place of a
_direct_ or _fanout_ exchange (or any other exchange for that matter),
_it will be slower_ than using the actual exchange. If you don't need
to delay messages, then use the actual exchange.

### Limitations

Delayed messages are stored in a Mnesia table (also see Limitations below)
with a single disk replica on the current node. They will survive a node
restart. While timer(s) that triggered scheduled delivery are not persisted,
it will be re-initialised during plugin activation on node start.
Obviously, only having one copy of a scheduled message in a cluster means
that losing that node or disabling the plugin on it will lose the
messages residing on that node.

This plugin was created with disk nodes in mind. RAM nodes are currently
unsupported and adding support for them is not a priority (if you aren't sure
what RAM nodes are and whether you need to use them, you almost certainly don't).

The plugin only performs one attempt at publishing each message but since publishing
is local, in practice the only issue that may prevent delivery is the lack of queues
(or bindings) to route to.

Closely related to the above, the mandatory flag is not supported by this exchange:
we cannot be sure that at the future publishing point in time

- there is at least one queue we can route to
- the original connection is still around to send a `basic.return` to

Current design of this plugin doesn't really fit scenarios
with a high number of delayed messages (e.g. 100s of thousands or millions).
See [#72](https://github.com/rabbitmq/rabbitmq-delayed-message-exchange/issues/72) for details.

### Disabling the Plugin

You can disable this plugin by calling `rabbitmq-plugins disable
rabbitmq_delayed_message_exchange` but note that **ALL DELAYED MESSAGES THAT HAVEN'T BEEN DELIVERED WILL BE LOST