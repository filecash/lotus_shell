# lotus_shell
lotus run script

## lotus_shell script
```
===
  |--init - 安装环境
      |--init.sh       - 初始化运行环境
      |--init-dev.sh   - 初始化编译环境
  |--run  - 运维脚本
      |--env.sh        - 环境变量
      |--2.daemon.sh   - 启动lotus节点
            ## 使用方法说明
            bash 2.daemon.sh        - 启动lotus
            bash 2.daemon.sh kill   - 关闭lotus
      |--3.init.sh     - 初始化矿工
      |--4.miner.sh    - 启动lotus-miner
            ## 使用方法说明
            bash 4.miner.sh         - 启动lotus-miner
            bash 4.miner.sh kill    - 关闭lotus-miner
            bash 4.miner.sh store   - 给lotus-miner增加miner_store目录，用来存储最后的落盘文件
      |--5.worker-***.sh - 启动lotus-worker
            ## 使用方法说明
            bash 5.worker-all.sh    - 启动全功能worker
            bash 5.worker-ap.sh     - 只启动addpiece功能worker
            bash 5.worker-app1.sh   - 只启动addpiece和PreCommit1功能worker
            bash 5.worker-app1p2.sh - 只启动addpiece、PreCommit1和PreCommit2功能worker
            bash 5.worker-p1.sh     - 只启动PreCommit1功能worker
            bash 5.worker-p2c.sh    - 只启动PreCommit2和Commit功能worker
            bash 5.worker-c.sh      - 只启动Commit功能worker
            bash 5.worker-kill.sh   - 关闭worker
      |--pledge-auto.sh  - 自动发任务脚本
            ## 使用方法说明
            nohup bash pledge-auto.sh 1200 20 >> ./auto-pledge.log 2>&1 &    ## 每间隔1200秒执行一次任务下发逻辑，总任务数维持在20个
      |--lotus.sh      - 全功能运维脚本 全功能运维脚本 全功能运维脚本
```

## lotus集群部署详细步骤
- 1.启动lotus节点，修改.lotus/config.toml文件，将【#  ListenAddress = "/ip4/127.0.0.1/tcp/1234/http"】里面的127.0.0.1替换为lotus节点的IP；
- 2.复制lotus节点机器下面的 .lotus/api .lotus/token 两个文件到lotus-miner矿工机器下面的.lotus目录；
- 3.启动lotus-miner，修改.lotusminer/config.toml文件，将【#  ListenAddress = "/ip4/127.0.0.1/tcp/2345/http"】里面的127.0.0.1替换为lotus-miner矿工的IP；
- 4.复制lotus节点机器下面的 .lotus/api .lotus/token 两个文件到lotus-worker矿工机器下面的.lotus目录；
- 5.复制lotus-miner矿工机器下面的 .lotusminer/api .lotusminer/token 两个文件到lotus-worker矿工机器下面的.lotusminer目录；
- 6.启动lotus-worker，集群部署成功。

