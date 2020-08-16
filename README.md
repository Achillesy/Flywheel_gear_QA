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

# History
## auto-qa
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
  * v0.2.9 add timestamp
  * v0.2.10 try to write to message.txt
  
  * v0.3.0 output config.json
  * v0.3.1 ~~two zip input~~ :shit:
  * v0.3.2 ~~var 'b_input'~~ :shit:
## auto-zip-qa
  * v0.0.1 ~~confict name~~ :shit:
  * v0.0.2 show config.json
  * v0.0.3 show flywheel tree
