# gear_QA
Build context for a Flywheel Gear that can run Matlab code.
> 屢讀屢叫絕，輒拍案浮一大白。 ![image](img/looking.svg)


# Tutorial

## Environment Setup
### Docker
  * Ubuntu Focal 20.04(LTS)
```bash
sudo aptitude remove docker docker-engine docker.io containerd runc
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates curl gnupg-agen software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
apt-cache madison docker-ce
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
docker login
docker run hello-world
sudo systemctl status docker
docker logout
```
### Flywheel Command-Line Interface
```bash
cd ~/Downloads/linux_amd64/
sudo mv ./fw /usr/local/bin
fw login <yourapikey>
fw logout
```
### Flywheel SDK
```bash
sudo aptitude install python3-pip
python3 -m pip install flywheel-sdk
```
## The Flywheel Environment

## The Run Script

## The Manifest

## The Dockerfile

## Testing/Debugging


# History
  * v0.1.0 COPY autoQA
  * v0.1.1 ~~Save file~~ :shit:
  * v0.1.2 ~~Change~~ path
  * v0.1.3 RUN chmod +x
  * v0.1.4 export LD_LIBRARY_PATH
  * v0.1.5 Success. :sunglasses:
