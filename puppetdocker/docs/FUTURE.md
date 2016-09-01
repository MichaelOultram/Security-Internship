# Future Plans

Here is a list of some of the features that I think would be pretty interesting
to add to this module. They start of reasonable and go somewhat insane. Some of
these features are also current limitations and are therefore listed in
[LIMITATIONS.md](./LIMITATIONS.md).

## Support 32 bit operating systems (and containers).

There are currently only 64 bit versions of docker available as packages. In a
[feature request](https://github.com/docker/docker/issues/136) crosbymichael
explained why there are no 32 bit packages.

> Supporting [32 bit hosts] in docker is easy but that hard work is around
> registry support to make sure that when you run docker pull debian you get
> the correct image depending on your arch. This is what makes the feature
> request non-trivial.
>
> — <cite>crosbymichael</cite>

Docker _can_ be compiled from source on a 32 bit machine but only 32 bit
containers will work. I propose that this module compiles docker from source
(use this [script](../files/docker-32bit-dependancies.sh) as a guideline) if we
are running in a 32 bit virtual machine.

The current base container we are using
([phusion/baseimage](https://github.com/phusion/baseimage-docker)) is 64 bit
and so this would need to be ported to a 32 bit image as well.

## Integrate into SecGen framework

Integrating this module into the SecGen framework will allow for more
interesting challenges. This task may seem slightly more challenging than
integrating a normal module as each container connects to the puppet server and
the nodes.pp file can change based on what other modules are installed (i.e. we
can not have two overlapping CIDRs).

## Change terminal prompt to include full hostname

This change should be a simple as changing the `PS1` environment variable to
`"\[\u@$(hostname -f): \w\]\$ "`. The goal is to make it easier for the
attacker to know where they are in the network.

## Resetting containers

It would be nice to be able to reset a container to a know "good"
configuration in case something goes wrong (i.e. the attacker accidentally
deletes something and makes the exercise impossible). Each container has an
image of the build container. If any of the containers are deleted, then a new
container is made from the image (thanks to the
[garethr-docker](https://github.com/garethr/garethr-docker) module). The only
problem is that not all the network adapters are not restored.

Probably the best way to restore the network adapters is to edit the docker-run
service file to run something like `docker network connect example example.vm
--ip 172.18.0.1` when a new container is made.

There is also the question of how does a attacker reset a container? The
attacker cannot have access to the docker command or else they would be able to
just ssh into any container. Originally I had it so that all the containers
would be reset whenever the virtual machine restarts. If the attacker wanted to
save their progress, then they would have to save the virtual machine's state.
A better way would be to write a custom script that is run as a privileged user
to reset the container. We just have to be careful that we don't introduce a
new way for the attacker to gain access to a container.

## Simulate routers/gateways better

This feature relates to the [gateway](../../gateway) module. Currently gateway
containers don't do as much as I would like as docker does it for me. For
instance all ip addresses are assigned by docker whereas in a real network a
DHCP server is running on the router.

In a real network, client machines often have their dns settings to point to
the router. The router then relays any dns requests to another dns server. It
would be nice if our simulated network could achieve this so that router
malware can be taught. Not all clients may have their dns settings pointing to
the router however.

Most routers have a web gui to configure settings like wifi passwords, dns
settings, ports forwarded, etc. Our simulated gateway does not have this.

## Simulate wireless access points

This feature seems tricky and I have no idea how I would pull this off.
