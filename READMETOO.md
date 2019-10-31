
## 步骤

将139.9.120.244定义为master华为云虚机；139.9.127.140定义为slave华为云虚机。

### 1. 在master拉取fabric-sdk-java 
```shell
cd /data/code/java/fabric-1.4.0
git clone https://github.com/jiangyang118/fabric-sdk-java.git
cd fabric-sdk-java
git checkout 
docker-compose -f 244.yaml up -d


```

### 2. 在slave拉取fabric-sdk-java 
```shell
cd /data/code/java/fabric-1.4.0
git clone https://github.com/jiangyang118/fabric-sdk-java.git
cd fabric-sdk-java
git checkout 
docker-compose -f 140.yaml up -d


```

### 3. 在本地运行end2endIT单元测试
```shell
clean test -Dtest=End2endIT

#日志如下
```

### 4. 在本地运行NetworkConfigIT单元测试
```shell
clean test -Dtest=NetworkConfigIT

#日志如下
```

### 5. 停止master和slave机器上的docker
```shell
#停止命令
docker-compose down
```
