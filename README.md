# gear_QA
Build context for a Flywheel Gear that can run Matlab code.
> 屢讀屢叫絕，輒拍案浮一大白。 ![image](img/looking.svg)

## Source code tree
```
/Docker/
     ├── Dockerfile     Docker配置
     ├── manifest.json  配置文件
     └── run            默认程序入口
/auto_QA/
     ├── flywheel/v0/   模拟环境
     |  ├── input/      输入文件
     |  ├── output/     输出文件
     |  └── config.json fw配置文件
     ├── fun_*.m        子程序
     ├── fun_fun_*.m    子程序
     ├── mccMake.sh     编译批处理
     └── run_ACR_test.m 主程序
```
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
