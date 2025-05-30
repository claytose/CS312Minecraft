# Course Project Part 2

---

**Author**: Sean Clayton  
**ID**: 934425200  
**Course**: CS 312 - System Administration  

---

## 1. Install Required Dependencies on Local Machine or VM
Required Dependenices:
   - Terraform v1.12.1
   - AWS CLI version 2.27.25
   - Ansible core version 2.16.3
   - git version 2.43.0 

1. Install Terraform:
   - Paste the following into the terminal with administrator privileges to install Terraform and verify download:
   ```bash
   sudo apt update && sudo apt install -y gnupg software-properties-common curl
   curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
   echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
   sudo tee /etc/apt/sources.list.d/hashicorp.list
   sudo apt update && sudo apt install terraform -y
   terraform -v
   ```
2. Install AWS CLI:
   - Paste the following into the terminal with administrator privileges to install AWS CLI and verify download:
   ```bash
   curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
   unzip awscliv2.zip
   sudo ./aws/install
   aws --version
   ```
3. Install Ansible:
   - Paste the following into the terminal with administrator privileges to install Ansible and verify download:
   ```bash
   sudo apt install software-properties-common -y
   sudo add-apt-repository --yes --update ppa:ansible/ansible
   sudo apt install ansible -y
   ansible --version
   ```
4. Install Git:
   - Paste the following into the terminal with administrator privileges to install Git and verify download:
   ```bash
   sudo apt update
   sudo apt install git -y
   git --version
   ```



---

## 2. Configure AWS Credentials

1. Login to AWS Academy (https://awsacademy.instructure.com/login/canvas)
2. Launch the AWS Learner Academy Lab
3. Click "Start Lab"
4. Click "AWS Details"
5. Click "Show" on the AWS CLI details.
6. Record the AWS Access Key ID, AWS Secret key, and the AWS Session Token.
7. Type `aws configure` into the terminal.
   - Fill out "AWS Access Key ID" and "AWS Secret Access Key" with keys recorded from AWS Academy.
   - Type "us-east-1" for "Default region name".
   - Click "Enter" for "Default output format."
8. Save the AWS information as variables in the terminal to be used in the scripts later using:
   ```bash
   export AWS_ACCESS_KEY_ID=YOUR_ACCESS_KEY_ID HERE
   export AWS_SECRET_ACCESS_KEY=YOUR SECRET_ACCESS_KEY HERE
   export AWS_SESSION_TOKEN=YOUR_SESSION_TOKEN_HERE
   ```

   
---

## 3. Create Terraform Files

On your local terminal:

1. Run the command `ssh-keygen -t rsa -b 4096 -C "claytose@oregonstate.edu"` to generate a public SSH key pair.
   - Replace "claytose@oregonstate.edu" with your own email.
   - Press "Enter" when prompted for the file to save the key in, take note of the default file.
2. Run the command `git clone https://github.com/claytose/CS312Minecraft.git` to clone this repository to local machine.
2. Run the command `cd CS312Minecraft` and then `cd terraform` to navigate to the terraform directory.
3. In the file called "mains.tf", replace the public_key value to the file that your key pair you generated in Step 1 is stored in:
   ```bash
   resource "aws_key_pair" "minecraft_key" {
   key_name   = "minecraft-key"
   public_key = file("/home/claytose/.ssh/id_rsa")
   }
   ```
3. Run the command `terraform init` to set up terraform files using the terraform scripts from the repository.
4. Run the command `terraform apply` to apply these changes.
   - Type `yes` when prompted to apply changes.
---

## 4. Record Public IP Address

1. Run: `18.212.189.37` to check the public IP address of the previously created Minecraft server.
   - Record this public IP address for later.

---

## 5. Install Minecraft Server

1. Create directory for minecraft server, run:
   - `mkdir minecraft`
   - `cd minecraft`
2. Download Minecraft server JAR (from https://www.minecraft.net/en-us/download/server) to instance by running:
   - `curl -O https://launcher.mojang.com/v1/objects/e6ec2f64e6080b9b5d9b471b291c33cc7f509733/server.jar`
3. Accept EULA:
   - Run: `echo "eula=true" > eula.txt`

---

## 6. Configure and Start Server

1. Create script file to launch from later
   - Run `nano start.sh`

2. Paste the following into the new file:

   ```bash
   #!/bin/bash
   java -Xmx1024M -Xms1024M -jar server.jar nogui
   ```

3. Next, need to make the script executable by running:
   - `chmod +x start.sh`
   - `./start.sh`

4. A message should be displayed on terminal confirming that server is running.

---

## 7. Setup Autostart

1. Open a new terminal and SSH into EC2 instance again (Step 3).
2. Type `cd minecraft` to navigate back to the Minecraft file.
3. Create a service file:
   - Run: `sudo nano /etc/systemd/system/minecraft.service`

4. Paste this into the file, and change path names if necessary:

   ```ini
   [Unit]
   Description=Minecraft Server
   After=network.target

   [Service]
   User=ec2-user
   WorkingDirectory=/home/ec2-user/minecraft
   ExecStart=/usr/bin/java -Xmx1024M -Xms1024M -jar server.jar nogui
   Restart=on-failure

   [Install]
   WantedBy=multi-user.target
   ```

5. Enable and start the service file by running each of these commands:

   ```bash
   sudo systemctl daemon-reexec
   sudo systemctl daemon-reload
   sudo systemctl enable minecraft
   sudo systemctl start minecraft
   ```

6. Verify that everything was set up correctly by running `sudo systemctl status minecraft`.
   - Should see that server is not running.
7. Reboot system by running `sudo reboot`.
8. Reconnect via SSH back into EC2 instance after it has rebooted.
9. Verify that server is now running by running `sudo systemctl status minecraft` again.
   - Should see that server is now active.

---

## 8. Verify that Server is Running Through Minecraft Client
1. Launch the Minecraft client.
2. Click `Multiplayer`, and then `Direct Connection`.
3. Enter the instance's public IP address into the `Server Address` field.
4. Click `Join Server` and see if server is up and running.
5. Play on the new server!



