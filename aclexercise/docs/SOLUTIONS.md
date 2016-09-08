# aclexercise Solutions

**This document contains SPOILERS for the exercise.** So don't read if you
ain't supposed to.

The acl.vm gateway forwards all ports to the server. SSH into the server using
`ssh root@acl.vm` using the password `rootpassword`. Read the file
`/root/token` to get the first token for the exercise.

As you are the root user, you can access the shadow file by just reading it.
Use JohnTheRipper to get the passwords for the accounts stored on the server.
The `013`, `133` and `145` users have a token in their home directory. This
will take some time so just leave it running and continue with the exercise.

By exploring the folder structure of the server, you should come across
`/backup/charlie`. This is a backup of charlie's account from another machine.
Inside charlie's backup is a copy of his private ssh key. Use nmap to find
other machines on the acl.vm network and use the private key to login to one of
them. There should be a token in `/home/charlie/token`. By looking in `/home`
you will notice that there are a few other accounts on the machine (alice, dan
and elvis).

Charlie has execute permissions inside dan's folder so to get dan's token, run
the command "cat /home/dan/token".

Charlie has read/write and execute privileges inside elvis's home folder, but
only elvis can access the token. Elvis has an executable program with an s bit
so that it runs as elvis. This program has a security vulnerability. Find and
exploit it.

Charlie can not access anything from alice's folder (and neither can elvis).
Elvis is however in the shadow group. Get the shadow file as elvis and crack
alice's password (should be pretty quick). Then login as alice and no token but
instead a hint. Alice has an account on both machines (she used the same
password twice) and so use ssh and login as alice on the other machine to
receive the token.

There is one more account on the other machine, bob. Alice has permission to
write to `/home/bob/.ssh/authorized_keys` and so alice can insert her own ssh
key to login as bob to receive the last token.
