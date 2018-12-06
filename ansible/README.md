# Hosts configuration with Ansible

Ansible is used to setup hosts:

* a Salt infra (master and minions) (`2018.3`)

## Install

Edit the **inventory** file :

```bash
[master]
<master_ip_address>         ansible_connection=ssh        ansible_user=pirate

[nodes]
<node1_ip_address>          ansible_connection=ssh        ansible_user=pirate
<node2_ip_address>          ansible_connection=ssh        ansible_user=pirate
<node3_ip_address>          ansible_connection=ssh        ansible_user=pirate
```

Tests :

    $ make check
    $ make debug


## Salt

* Configure the master:

    $ make salt-master

* Configure the minions:

    $ make salt-minions

* Restart the salt-minion service on each minions

* On the master, accept minions keys.

* Check infra:

    $ rock64@jarvis-master:~$ sudo salt-key -L
    Accepted Keys:
    jarvis-master
    jarvis-node1.localdomain
    jarvis-node2.localdomain
    jarvis-node3.localdomain
    jarvis-zero1.localdomain
    Denied Keys:
    Unaccepted Keys:
    Rejected Keys:
