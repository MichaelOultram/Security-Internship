# Workarounds

The current state of this module is not perfect, but it is generally in a
working state. However there are a few things that could go wrong and here are
some of the current workarounds.

## DNS not resolving

A dns server is running on the host virtual machine but for some reason the
virtual machine is using another dns server. Change the dns settings to point
to 127.0.0.1 (or 172.17.0.1) so that `.vm` hostnames can be resolved.

## fixip task broken in puppet

Puppet may say the fixip task failed. This is due to a race condition that I
ran out of time to fix. Basically puppet sometimes tries to run that task
before the container is ready. It doesn't matter too much if this task is
missed as when the virtual machine restarts this task will be run again. Or you
can run `docker exec example.vm bash -c "/etc/my-init.d/fixip.sh"`.

## Gateway containers not forwarding ports.

Again another race condition, but this time with docker. All of the iptable
rules have been saved (and were loaded) but docker decided to overwrite the
loaded rules. Restarting the virtual machine should fix this issue or you can
run `docker exec example.vm bash -c "/etc/my-init.d/fixmisc.sh"`.

## Rebuilding a single container

This is more of a convenience workaround. It can take puppet ages to create a
virtual machine (depending on how much you install) but when it is all done you
realise that one of the containers isn't working. It turns out you misspelled
the module name (or there is a bug in the puppet code) and puppet just doesn't
configure anything for that container. Instead of resetting the entire virtual
machine and waiting ages for it to be reconfigured, you could just rebuild that
one container.

To do this first fix the error in puppet and reset any ssh keys for that
container on the puppet server. Then create a new build container with the
correct hostname using `docker run -it --privileged --hostname=example.vm
--name=build-example.vm puppet-base bash -c "/build.sh"` (or run the script in
a shell in the build container for more debugging). Once this is complete and
the container is stopped, you need to replace the saved image. First delete the
old image using `docker rmi -f example.vm` and then save the newly build
container using `docker commit --change 'CMD /sbin/my_init' build-example.vm
example.vm`. Finally destroy the container running the old image and a new one 
will be created with the new image using `docker rm -f example.vm`. You may
need to connect the container to a network because of a limitation.
