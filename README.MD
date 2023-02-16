# Terraform + Ansible + App Node.js

## Prerequisite:

Make sure the following applications are installed and are set in the enviromental path:

- AWS CLI
- Terraform
- Ansible 

Export your `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` as environment variables, and run `aws configure` to complete setup:

```shell
export AWS_ACCESS_KEY_ID=<access-key>
export AWS_SECRET_ACCESS_KEY=<secret-key>
```

--------------
## Usage

- Terraform + Ansible
- App in node.js "Bem vindo Luiz Carlos Nascimento Junior!"

--------------

## Files and Directories:

```
├── ansible
│   ├── key (add your key pair here)
│   ├── nginx
│   |   └── Dockerfile
│   |   └── nginx.conf
│   └── ansible.cfg
│   └── hosts
|   └── provisioning.yml
├── app
│   └── Dockerfile
│   └── index.js
│   └── package.json
├── terraform
|   ├── main.tf
|   ├── outputs.tf
├── Doc
├── README.md
```

## Tools Used:

Terraform: To compile, validate, fmt, plan, apply and destroy,
```shell
terraform validate
terraform fmt
terraform plan
terraform graph
terraform apply
terraform destroy
```

--------------
## Application

- Application in node.js
- I created the application image 'desafio-node:latest', I published the image on dockerhub. (thecalifornia16/desafio-node:latest)
- In the '**app**' folder you have the '**index.js**' file in case you want to change something and the '**Dockerfile**' for building the application.


--------------
## Getting started

#### **TERRAFORM - Creating the infrastructure on AWS**

Note: Before starting the infrastructure creation, validate that you already have a key pair in AWS, if in doubt follow the link to create a key pair
https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/create-key-pairs.html

- With the key Pairs created, change line 140 in the file '**main.tf**' inside the '**terraform**' folder. (Ex.: 'terraform-ansible') 
    > key_name                    = "terraform-ansible" #Enter your Key Pairs AWS
- After modification copy your key pairs into the folder '**ansible -> key**' (Files and Directories)

To run the application, simply execute the following command in the '**terraform**' folder:

```shell
terraform init
terraform plan
terraform apply 

```

Terraform will create all the resources in AWS, you can then use ansible-playbook to deploy applications and docker.


--------------
#### **ANSIBLE - Installation and Configuration of applications in the environment**

Note: Once the infrastructure provisioning is complete, will display in the output the 'publicIp' for access to the server, get the IP and add it to the '**hosts**' file inside the '**ansible**' folder to run the playbook on the server.
```
[webserver]
54.176.126.145    #Here you put the 'publicIp' that came in the terraform output or your EC2 that was created in AWS
```

Ansible-playbook: To run it, go to the "**ansible**" folder:

```shell
Ex.: ansible-playbook provisioning.yml -u ubuntu --private-key key/terraform-ansible.pem -i hosts
ansible-playbook provisioning.yml -u ubuntu --private-key key/<your private key>.pem -i hosts
```

--------------
## References HTTPS

- For HTTPS you could use this one "community.crypto.acme_certificate module – Create SSL/TLS certificates with the ACME protocol"
https://docs.ansible.com/ansible/latest/collections/community/crypto/acme_certificate_module.html#ansible-collections-community-crypto-acme-certificate-module

- You could use Letsencrypt (this one I used a lot on ubuntu servers to generate certificate)
https://www.digitalocean.com/community/tutorials/how-to-acquire-a-let-s-encrypt-certificate-using-ansible-on-ubuntu-18-04

- Additional references HTTPS
https://github.com/geerlingguy/ansible-role-nginx
https://medium.com/beambenefits/automated-ssl-management-with-docker-nginx-proxy-letsencrypt-9ac295d926a8
https://gist.github.com/mattiaslundberg/ba214a35060d3c8603e9b1ec8627d349


--------------
## Authors

* **Luiz Carlos Nascimento Junior**