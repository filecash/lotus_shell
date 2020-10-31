# lotus_shell
lotus run script

## lotus_shell script
---
  |--init - 安装环境
      |--init.sh       - 初始化运行环境
      |--init-dev.sh   - 初始化编译环境
  |--run  - 运维脚本
      |--2.daemon.sh   - 启动lotus节点
      |--3.init.sh     - 初始化矿工
      |--4.miner.sh    - 启动lotus-miner
      |--5.worker-***.sh - 启动lotus-worker
      |--pledge-auto.sh  - 自动发任务脚本
      |--lotus.sh      - 全功能运维脚本 全功能运维脚本 全功能运维脚本
      
## lotus集群部署详细步骤
- 1.启动lotus节点，修改.lotus/config.toml文件，将【#  ListenAddress = "/ip4/127.0.0.1/tcp/1234/http"】里面的127.0.0.1替换为lotus节点的IP；
- 2.复制lotus节点机器下面的 .lotus/api .lotus/token 两个文件到lotus-miner矿工机器下面的.lotus目录；
- 3.启动lotus-miner，修改.lotusminer/config.toml文件，将【#  ListenAddress = "/ip4/127.0.0.1/tcp/2345/http"】里面的127.0.0.1替换为lotus-miner矿工的IP；
- 4.复制lotus节点机器下面的 .lotus/api .lotus/token 两个文件到lotus-worker矿工机器下面的.lotus目录；
- 5.复制lotus-miner矿工机器下面的 .lotusminer/api .lotusminer/token 两个文件到lotus-worker矿工机器下面的.lotusminer目录；
- 6.启动lotus-worker，集群部署成功。

