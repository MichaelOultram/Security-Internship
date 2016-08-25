# Phishing module

This module creates a phishing-friendly environment for the purpose of learning how to create an attack/defense in three different methods:

- Web/Email
- PDF files
- Macros (VBA)

## Requirements

- puppetlabs-java module
- puppetdocker module
- metasploit module
- mailserver module
- sshserver module
- genuser module

## How to use

This module provides a web server and a email server for an attacker to breach into the second container (the victim). The setup is as follows:

- Attacker user (uses metasploit for attacks);
- Email server (processes the emails sent between the attacker and the victim)
- Webserver running a hiring website (used for pdf and macros attacks)
- Victim user (a script-driven user which will behave accordingly. It will open unread emails and their attachments and access the files on the webserver. Will also have preinstalled Acrobat Reader 8.1.2 and Libreoffice)

## Characters

The users/servers involved in this setup are the ones above. Here you have a wider description of how they behave

### Attacker

```
```
