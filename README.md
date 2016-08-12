# Security Challenge Modules

This repository contains a bunch of puppet modules to setup computer security based challenges inside a virtual machine. Most of the modules include their own documentation but for more general documentation then checkout the [_docs folder](_docs).

**These puppet modules contain security vulnerabilities and are not intended for live machines.**

## Overview of the included modules

### Exercise modules

Module Name                                          | Current Module Status | [SecGen Framework Supported](https://github.com/SecGen/SecGen) | Brief Description
---------------------------------------------------- | --------------------- | -------------------------------------------------------------- | ---------------------------------------------------------
[aclexercise](./aclexercise)                         | 75% complete          | no                                                             | Access control list capture the flag exercise
[ctf_buffer_overflow](./ctf_buffer_overflow)         | done                  | yes                                                            | Buffer overflow capture the flag exercise
[ctf_java_protocols](./ctf_java_protocols)           | done                  | yes                                                            | Cryptography protocols capture the flag exercise
[ctf_reverse_engineering](./ctf_reverse_engineering) | done                  | yes                                                            | Reverse engineering capture the flag exercise
[phishing](./phishing)                               | prototype             | no                                                             | Prototype for sending phishing emails to scripted victims

### Helper modules

Module Name                    | Current Module Status | [SecGen Framework Supported](https://github.com/SecGen/SecGen) | Brief Description
------------------------------ | --------------------- | -------------------------------------------------------------- | -------------------------------------------------------------------
[gateway](./gateway)           | done                  | no                                                             | Configures a container to be a network gateway
[gentoken](./gentoken)         | done                  | yes                                                            | Generates capture the flag tokens
[genuser](./genuser)           | done                  | no                                                             | Creates users easier than puppet does
[mailserver](./mailserver)     | usable                | no                                                             | Configures a postfix/dovecot unencrypted mailserver
[puppetdocker](./puppetdocker) | usable                | no                                                             | Creates containers and networks to simulate the internet
[sshserver](./sshserver)       | done                  | no                                                             | Configures an ssh server for password authentication and root login

### Package installer modules

Module Name                  | Current Module Status | [SecGen Framework Supported](https://github.com/SecGen/SecGen) | Brief Description
---------------------------- | --------------------- | -------------------------------------------------------------- | -----------------------------------------------
[adobereader](./adobereader) | done                  | no                                                             | Installs Adobe Reader 8.1.2 through wine
[clang](./clang)             | obsolete              | yes                                                            | Installs a c compiler
[ida](./ida)                 | done                  | yes                                                            | Installs ida
[jdgui](./jdgui)             | done                  | no                                                             | Installs jdgui
[metasploit](./metasploit)   | done                  | no                                                             | Installs metasploit
[wine](./wine)               | done                  | no                                                             | Installs wine for windows applications in linux
[wireshark](./wireshark)     | done                  | yes                                                            | Installs wireshark
