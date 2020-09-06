# gear_QA
Build context for a Flywheel Gear that can run Matlab code.
> 屢讀屢叫絕，輒拍案浮一大白。 ![image](img/looking.svg)

# Source code tree
```
/Docker/
     ├── Dockerfile     Docker配置
     ├── manifest.json  配置文件
     └── run            默认程序入口
/auto_QA/
     ├── flywheel/v0/   模拟环境
     │ ├── input/       输入文件夹
     │ ├── output/      输出文件夹
     │ └── config.json  fw配置文件
     ├── fun_*.m        子程序
     ├── fun_fun_*.m    子程序
     ├── mccMake.sh     编译批处理
     └── run_ACR_test.m 主程序
```
# Step by Step
## Step 1. build docker image
```bash
docker pull flywheel/matlab-mcr:v97
docker build --no-cache -t ahsoka/matlab-mcr:0.1.0 .
docker image ls
docker container run -it --rm <IMAGE ID> /bin/bash
docker container ls --all
docker container rm <IMAGE ID>
```
## Step 2. build matlab code
```bash
bash mccMake.sh
./autoQA
```
## Step 3. debug at local
```bash
cd /flywheel/v0
bash prerun.sh
```
## Step 4. debug in image
```bash
cd /flywheel/v0
bash testImage.sh
./run
```
in docker container
```bash
cp -R /execute/. /flywheel/v0
cd /flywheel/v0
./run
```

## Step 5. upload
```bash
fw gear local
fw gear upload
docker image ls
docker image rm <IMAGE ID>
```
