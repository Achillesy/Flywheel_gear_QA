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
