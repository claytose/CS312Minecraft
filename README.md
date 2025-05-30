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
   - nmap version 

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
3. Install AWS CLI:
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
   - Paste the following into the terminal with administrator privileges to install nmap and verify download:
   ```bash
   sudo apt update
   sudo apt install nmap -y
   nmap --version
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
8. Save the AWS information as environment variables in the terminal to be used in the scripts later using:
   ```bash
   export AWS_ACCESS_KEY_ID=<YOUR_ACCESS_KEY_ID HERE>
   export AWS_SECRET_ACCESS_KEY=<YOUR SECRET_ACCESS_KEY HERE>
   export AWS_SESSION_TOKEN=<YOUR_SESSION_TOKEN_HERE>
   ```

   
---

## 3. Create Terraform Files

On your local terminal:

1. Run the command `ssh-keygen -t rsa -b 4096 -C "<your_email>"` to generate a public SSH key pair.
   - Press "Enter" when prompted for the file to save the key in, take note of the default file.
2. Run the command `git clone https://github.com/claytose/CS312Minecraft.git` to clone this repository to local machine.
2. Run the command `cd CS312Minecraft` and then `cd terraform` to navigate to the terraform directory.
3. In the file called "mains.tf", replace the public_key file location to the file that your key pair you generated in Step 3.1 is stored in:
   ```bash
   resource "aws_key_pair" "minecraft_key" {
   key_name   = "minecraft-key"
   public_key = file("<your_file_location>")
   }
   ```
3. Run the command `terraform init` to set up terraform files using the terraform scripts from the repository.
4. Run the command `terraform apply` to apply these changes.
   - Type `yes` when prompted to apply changes.
---

## 4. Record Public IP Address

1. Run: `terraform output public_ip` to check the public IP address of the previously created Minecraft server.
   - Record this public IP address to use in the next step.

---

## 5. Create and Run Ansible Files

1. Run the command `cd ..` to go back to the parent directory (CS312Minecraft).
2. Run the command `cd ansible` to access the required Ansible files.
3. In the file titled "inventory.ini", change the <public_ip> value to the IP address you copied down in Step 4.1.
4. Run the following command to run the playbook with the required specifications:
   ```bash
   ansible-playbook -i inventory.ini playbook.yml
   ```
5. Type `yes` to continue.
---

## 7. Verify Server is Running through nmap

1. After Ansible finishes running the playbook, the Minecraft server should be set up. Run the following command with the IP address from Step 4.1 to verify the server is up and running:
   ```bash
   nmap -sV -Pn -p T:25565 <public-ip>
   ```
2. The output should look something like this:
   - PORT      STATE SERVICE   VERSION
     25565/tcp open  minecraft Minecraft 1.21.5

---

## 8. (Optional) Verify that Server is Running Through Minecraft Client
1. Launch the Minecraft client.
2. Click `Multiplayer`, and then `Direct Connection`.
3. Enter the instance's public IP address into the `Server Address` field.
4. Click `Join Server` and see if server is up and running.
5. Play on the new server!



