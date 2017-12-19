<<<<<<< HEAD
# Kubernetes installation with Ansible
=======
# Ansible
>>>>>>> cad6e67d03ffd6cfde5092c936ecc749c726f156

Ansible is used to setup:

* [Kubernetes](Kubernetes.md)
* [Home Assistant](HomeAssistant.md)

## Install

<<<<<<< HEAD
Install *Ansible* on the master:
=======
Install Ansible:
>>>>>>> cad6e67d03ffd6cfde5092c936ecc749c726f156

	$ sudo apt install python-dev libffi-dev
	$ sudo pip install ansible

Edit the **inventory** file :

	[master]
<<<<<<< HEAD
    <master_ip_address>         ansible_connection=ssh        ansible_user=pirate
=======
	<master_ip_address>         ansible_connection=ssh        ansible_user=pirate
>>>>>>> cad6e67d03ffd6cfde5092c936ecc749c726f156

	[nodes]
	<node1_ip_address>          ansible_connection=ssh        ansible_user=pirate
	<node2_ip_address>          ansible_connection=ssh        ansible_user=pirate
<<<<<<< HEAD
	<node3_ip_address>          ansible_connection=ssh        ansible_user=pirate
=======
	<node3_ip_address>          ansible_connection=ssh        ansible_user=pirate 

	[ha]
	<ha_ip_address>             ansible_connection=ssh        ansible_user=pirate
>>>>>>> cad6e67d03ffd6cfde5092c936ecc749c726f156

Test :

	$ ansible all -m ping -i inventory

### Update

<<<<<<< HEAD
## Usage

### Setup

	$ ansible-playbook -i inventory setup.yml
=======
        $ ansible-playbook -i inventory update.yml --check

        PLAY [Update HypriotOS and Kubernetes components] ******************************************************************************************************************************************************************

        TASK [Gathering Facts] *********************************************************************************************************************************************************************************************
        ok: [192.168.1.26]
        ok: [192.168.1.20]
        ok: [local]

        TASK [update : Update APT package] *********************************************************************************************************************************************************************************
        changed: [192.168.1.26]
        changed: [192.168.1.20]
        changed: [local]

        TASK [update : Upgrade APT package] ********************************************************************************************************************************************************************************
        changed: [192.168.1.26]
        changed: [192.168.1.20]
        changed: [local]
>>>>>>> cad6e67d03ffd6cfde5092c936ecc749c726f156

        PLAY RECAP *********************************************************************************************************************************************************************************************************
        192.168.1.20               : ok=3    changed=2    unreachable=0    failed=0
        192.168.1.26               : ok=3    changed=2    unreachable=0    failed=0
        local                      : ok=3    changed=2    unreachable=0    failed=0

### Update

	$ ansible-playbook -i inventory update.yml


### Reset

	$ ansible-playbook -i inventory reset.yml
