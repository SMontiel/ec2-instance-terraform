# ec2-instance

IasC to provision an EC2 instance with Docker installed.

## Access using SSH

``` bash
ssh -i "~/.ssh/id_ed25519.pub" ubuntu@(terraform output --raw instance_ip)
```

## Setup instance

```bash
sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo groupadd docker
sudo usermod -a -G docker ubuntu
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
sudo apt upgrade -y
```
