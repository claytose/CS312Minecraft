# Course Project Part 2

---

**Author**: Sean Clayton  
**ID**: 934425200  
**Course**: CS 312 - System Administration  

---


Background
===================

This tutorial walks users through a step-by-step process to deploy a Minecraft server on AWS using Infrastructure as Code (IaC) tools. The goal is to teach basic system administration and automation by leveraging popular tools like Terraform, Ansible, and AWS CLI. By following the guide, users will learn how to provision cloud infrastructure, run scripts, securely connect to a virtual machine, install necessary dependencies, and configure a Minecraft server to start automatically and remain persistent across reboots. This tutorial also demonstrates practical DevOps workflows, such as using GitHub for source control and validating deployment with tools like nmap.

Requirements
===================
   - User must be using Linux (Ubuntu) to run the specific commands used in this tutorial.
   - Must have an active AWS Learner Academy Account to access credentials
   - Required Dependenices:
      - Terraform v1.12.1
      - AWS CLI version 2.27.25
      - Ansible core version 2.16.3
      - git version 2.43.0 
      - nmap version 7.94
      - UnZip version 6.0
      - netcat version 1.226-1ubuntu2
   - User must configure AWS credential.
   - Local machine or VM must have Internet access.
   - AWS credentials and CLI are required.
   - The user will set environment variables as defined in Step 3.
   - The user will need to make or have a public key.
   - The user will need to have the ability to change file permissions.


Diagram of Major Steps
===================
<pre>
+---------------------------+
| 1. Configure Environment  |
| - Install Terraform, CLI |
| - Install Ansible, Git   |
+------------+-------------+
             |
             v
+---------------------------+
| 2. Set Up AWS Credentials |
| - Get temp credentials    |
| - Set environment vars    |
+------------+-------------+
             |
             v
+---------------------------+
| 3. Run Deployment Script  |
| - Enable permissions      |
| - Run SCript              |
+------------+-------------+
             |
             v
+---------------------------+
| 4. Verify Server Running  |
| - Use nmap or Minecraft   |
|   client to connect       |
+---------------------------+
</pre>

Steps
===================

## 1. Install Required Dependencies on Local Machine or VM

NOTE: Commands for required dependencies may need to be put in line by line.

1. Open up a terminal or command line of your choice with administrator privileges on your local machine or VM.
2. Install Terraform:
   - Paste the following into the terminal with to install Terraform and verify download:
   ```bash
   sudo apt update && sudo apt install -y gnupg software-properties-common curl
   curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
   echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
   sudo tee /etc/apt/sources.list.d/hashicorp.list
   sudo apt update && sudo apt install terraform -y
   terraform -v
   ```
3. Install UnZip:
   - Paste the following into the terminal to install UnZip and verify download:
   ```bash
   sudo apt install unzip
   unzip --version
   ```
4. Install AWS CLI:
   - Paste the following into the terminal to install AWS CLI and verify download:
   ```bash
   curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
   unzip awscliv2.zip
   sudo ./aws/install
   aws --version
   ```
4. Install Ansible:
   - Paste the following into the terminal to install Ansible and verify download:
   ```bash
   sudo apt install software-properties-common -y
   sudo add-apt-repository --yes --update ppa:ansible/ansible
   sudo apt install ansible -y
   ansible --version
   ```
5. Install git:
   - Paste the following into the terminal to install git and verify download:
   ```bash
   sudo apt update
   sudo apt install git -y
   git --version
   ```
6. Install nmap:
   - Paste the following into the terminal to install nmap and verify download:
   ```bash
   sudo apt update
   sudo apt install nmap -y
   nmap --version
   ```
7. Install netcat:
   - Paste the following into the terminal to install netcat and verify download:
   ```bash
   sudo apt install netcat-openbsd
   dpkg -l netcat-openbsd
   ```

---

## 2. Record AWS Credentials

1. Login to AWS Academy (https://awsacademy.instructure.com/login/canvas)
2. Launch the AWS Learner Academy Lab.
3. Click `Start Lab`
4. Click `AWS Details`
5. Click `Show` on the AWS CLI details.
6. Record the AWS Access Key ID, AWS Secret key, and the AWS Session Token.

---

## 3. Set Environment Variables

1. Save the AWS information as environment variables in the terminal to be used in the scripts later using:
   ```bash
   export AWS_ACCESS_KEY_ID=<YOUR_ACCESS_KEY_ID HERE>
   export AWS_SECRET_ACCESS_KEY=<YOUR SECRET_ACCESS_KEY HERE>
   export AWS_SESSION_TOKEN=<YOUR_SESSION_TOKEN_HERE>
   ```
   - Need to replace each of the fields with your AWS information saved from Step 2.6.

---

## 4. Clone GitHub Repository

1. Run the command `git clone https://github.com/claytose/CS312Minecraft.git` to clone this repository.

---

## 5. Change Permissions for Deployment Script

1. Run the command `cd CS312Minecraft` to navigate to the repository directory.
2. Run the command `chmod +x deploy.sh` to give the script permission to execute.

---

## 6. Run Deployment Script

1. Run the deployment script:
   - `./deploy.sh`
   - This will:
      - Run Terraform to provision infrastructure
      - Capture the EC2 public IP
      - Update the inventory.ini file
      - Run the Ansible playbook to configure the server
2. Type `yes` when prompted to connect to the instance.
3. Take note of the public IP address that corresponds to recently configured server.
   - Should be a line that is printed that states `Public IP is: <public_ip>`.

---

## 7. Verify Server is Running Through nmap

1. After Ansible finishes running the playbook, the Minecraft server should be set up. Run the following command with the instance's IP address from Step 6.3 to verify the server is up and running:
   ```bash
   nmap -sV -Pn -p T:25565 <public-ip>
   ```
2. The output should look something like this:
   - PORT      STATE SERVICE   VERSION
   - 25565/tcp open  minecraft Minecraft 1.21.5
3. If so, your Minecraft server is up and running!
---

## 8. (Optional) Verify that Server is Running Through Minecraft Client
1. Launch the Minecraft client.
2. Click `Multiplayer`, and then `Direct Connection`.
3. Enter the instance's public IP address into the `Server Address` field.
4. Click `Join Server` and see if server is up and running.
5. Play on the new server!


## Resources:
   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/finding-an-ami.html
   - https://phoenixnap.com/kb/how-to-install-use-nmap-scanning-linux
   - https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
   - https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html
   - https://git-scm.com/downloads
   - https://docs.aws.amazon.com/corretto/latest/corretto-21-ug/what-is-corretto-21.html
   - https://www.minecraft.net/en-us/download/server
   - https://docs.github.com/en/get-started/writing-on-github
   - https://medium.com/@antoinecichowicz/minecraft-server-on-aws-ecs-fargate-using-terraform-6626932a75c5
