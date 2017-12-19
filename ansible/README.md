# Kubernetes installation with Ansible

Simple Ansible playbook to install and configuration Kubernetes on Raspberry PI

## Install

Install *Ansible* on the master:

	$ sudo apt install python-dev libffi-dev
	$ sudo pip install ansible

Edit the **inventory** file :

	[master]
    <master_ip_address>         ansible_connection=ssh        ansible_user=pirate

	[nodes]
	<node1_ip_address>          ansible_connection=ssh        ansible_user=pirate
	<node2_ip_address>          ansible_connection=ssh        ansible_user=pirate
	<node3_ip_address>          ansible_connection=ssh        ansible_user=pirate

Test :

	$ ansible all -m ping -i inventory


## Usage

### Setup

	$ ansible-playbook -i inventory setup.yml


### Update

	$ ansible-playbook -i inventory update.yml


### Reset

	$ ansible-playbook -i inventory reset.yml
