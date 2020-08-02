# gear_QA
Build context for a Flywheel Gear that can run Matlab code.
> 屢讀屢叫絕，輒拍案浮一大白。 ![image](img/looking.svg)


# Tutorial
[Gear Building Tutorial](https://docs.flywheel.io/hc/en-us/articles/360041766774-Gear-Building-Tutorial)
## Environment Setup
### Docker
  * Ubuntu Focal 20.04(LTS)
```bash
sudo apt-get remove docker docker-engine docker.io containerd runc
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
docker version
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
sudo apt-get install python3-pip
python3 -m pip install flywheel-sdk
```

## "Hello World"
We'll develop this example gear in the following steps:
1. Develop a working **run script**
2. Generate a **Manifest**
3. Generate a **Dockerfile**
4. Test the gear locally
5. Upload to Flywheel


## The Flywheel Environment
```
/flywheel/v0/
     ├── input/
     ├── output/
     └── config.json
```

## The Run Script

## The Manifest

## The Dockerfile
```bash
docker pull alpine:latest
docker image ls
docker image rm <IMAGE_ID> -f
docker build -t ahsoka/alpine-python:0.1.0 .
docker push ahsoka/alpine-python:0.1.0
```

## Testing/Debugging
```bash
fw gear local --my_name="Ahsoka Tano" --message_file=message.txt --num_rep=3
fw gear upload
```

# Building A Matlab Gear
[Background](https://docs.flywheel.io/hc/en-us/articles/360019040653-Building-A-Matlab-Gear)

[Matlab Compiler Runtime](https://www.mathworks.com/products/compiler/matlab-runtime.html)

## Example Matlab Gears
[Gannet](https://github.com/scitran-apps/gannet): Build context for a Gear that can run Gannet. Gannet is a software package designed for the analysis of edited magnetic resonance spectroscopy (MRS) data. 

## Matlab Code
```bash
mcc -m run_ACR_test.m -o autoQA
rm mccExcludedFiles.log readme.txt requiredMCRProducts.txt run_autoQA.sh 
./autoQA
docker run --rm -ti \
    -v </path/to/MSAE/parent/folder>:/execute \
    flywheel/matlab-mcr:v97 \
    /execute/autoQA [<any input arguments>]
```

## Available MCR images via Flywheel Dockerhub
```bash
docker pull flywheel/matlab-mcr:v97
docker build --no-cache -t ahsoka/matlab-mcr:0.1.0 .
docker image ls
docker container run -it --rm <IMAGE ID> /bin/bash
docker container ls --all
docker container rm <IMAGE ID>
fw gear local
fw gear upload
```

# History
  * v0.1.0 COPY autoQA
  * v0.1.1 ~~Save file~~ :shit:
  * v0.1.2 ~~Change path~~ :shit:
  * v0.1.3 RUN chmod +x
  * v0.1.4 export LD_LIBRARY_PATH
  * v0.1.5 Success. :sunglasses:
  * v0.1.6 test ENTRYPOINT

  * v0.2.0 ahsoka/matlab-mcr-python
  * v0.2.1 ~~bad param~~ :shit:
  * v0.2.2 print config.json
  * v0.2.3 run_ACR_test.m pass
  * v0.2.5 mkdir $OUTPUT_DIR
  * v0.2.6 cp $INPUT_DIR/output_file $OUTPUT_DIR
  * v0.2.7 run_ACR_test.m write to output file
  * v0.2.8 Circle_Imaging_MR2.txt
