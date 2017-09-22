# Kubernetes / Ansible

Simple Ansible playbook to install and configuration Kubernetes on Raspberry PI

## Install

Install Ansible on the master:

	$ sudo apt install python-dev libffi-dev
	$ sudo pip install ansible

Edit the *inventory* file : 

	[master]
	localhost         ansible_connection=local

	[nodes]
	<node1_ip_address> ansible_connection=ssh        ansible_user=pirate
	<node2_ip_address> ansible_connection=ssh        ansible_user=pirate
	<node3_ip_address> ansible_connection=ssh        ansible_user=pirate 

Test :

	$ ansible all -m ping -i inventory


## Usage

### Setup

	$ ansible-playbook -i inventory setup.yml                                                                                                                                                

	PLAY [Setup Jarvis / Raspberry Pi Kubernetes cluster] ***********************************************************************************************************************************
	
	TASK [Gathering Facts] ******************************************************************************************************************************************************************
	ok: [192.168.1.26]
	ok: [local]
	ok: [192.168.1.20]
	
	TASK [kubernetes : Update cache] ********************************************************************************************************************************************************
	ok: [192.168.1.26]
	ok: [192.168.1.20]
	ok: [local]
	
	TASK [kubernetes : Install necessary tools] *********************************************************************************************************************************************
	ok: [192.168.1.26] => (item=[u'apt-transport-https', u'bash-completion', u'jq'])
	ok: [192.168.1.20] => (item=[u'apt-transport-https', u'bash-completion', u'jq'])
	ok: [local] => (item=[u'apt-transport-https', u'bash-completion', u'jq'])
	
	TASK [kubernetes : Setup Docker to version 1.12* (the latest supported by Kubernetes)] **************************************************************************************************
	ok: [local]
	ok: [192.168.1.26]
	ok: [192.168.1.20]
	
	TASK [kubernetes : Downgrade docker] ****************************************************************************************************************************************************
	ok: [192.168.1.20]
	ok: [192.168.1.26]
	ok: [local]
	
	TASK [kubernetes : Creates Docker systemd configuration directory] **********************************************************************************************************************
	ok: [local]
	ok: [192.168.1.26]
	ok: [192.168.1.20]
	
	TASK [kubernetes : Install Docker customization] ****************************************************************************************************************************************
	ok: [local]
	ok: [192.168.1.26]
	ok: [192.168.1.20]
	
	TASK [kubernetes : Add Kubernetes Repo Key] *********************************************************************************************************************************************
	ok: [192.168.1.26]
	ok: [192.168.1.20]
	ok: [local]
	
	TASK [kubernetes : Add Kubernetes Repo] *************************************************************************************************************************************************
	ok: [192.168.1.26]
	ok: [local]
	ok: [192.168.1.20]
	
	TASK [kubernetes : Update APT package cache and upgrade] ********************************************************************************************************************************
	changed: [192.168.1.26]
	changed: [192.168.1.20]
	changed: [local]
	
	TASK [kubernetes : Install Kubernetes components] ***************************************************************************************************************************************
	ok: [192.168.1.20] => (item=[u'kubeadm=1.7.5-00', u'kubectl=1.7.5-00', u'kubelet=1.7.5-00', u'kubernetes-cni=0.5.1-00'])
	ok: [local] => (item=[u'kubeadm=1.7.5-00', u'kubectl=1.7.5-00', u'kubelet=1.7.5-00', u'kubernetes-cni=0.5.1-00'])
	changed: [192.168.1.26] => (item=[u'kubeadm=1.7.5-00', u'kubectl=1.7.5-00', u'kubelet=1.7.5-00', u'kubernetes-cni=0.5.1-00'])
	
	TASK [kubernetes : stat] ****************************************************************************************************************************************************************
	ok: [local]
	ok: [192.168.1.26]
	ok: [192.168.1.20]
	
	TASK [kubernetes : command] *************************************************************************************************************************************************************
	skipping: [192.168.1.26]
	changed: [192.168.1.20]
	changed: [local]
	
	PLAY RECAP ******************************************************************************************************************************************************************************
	192.168.1.20               : ok=13   changed=2    unreachable=0    failed=0   
	192.168.1.26               : ok=12   changed=2    unreachable=0    failed=0   
	local                      : ok=13   changed=2    unreachable=0    failed=0 
	
		
### Update

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
	
	PLAY RECAP *********************************************************************************************************************************************************************************************************
	192.168.1.20               : ok=3    changed=2    unreachable=0    failed=0   
	192.168.1.26               : ok=3    changed=2    unreachable=0    failed=0   
	local                      : ok=3    changed=2    unreachable=0    failed=0   


