#以下命令在140服务器执行
CURRENT_DIR=$PWD
cd /data/code/java/fabric-1.4.0/fabric-sdk-java/src/test/fixture/sdkintegration
rm -rf ./e2e-2Orgs/v1.3/*
mv  1.3.zip ./e2e-2Orgs/v1.3/
cd  ./e2e-2Orgs/v1.3/
unzip 1.3.zip
cd "$CURRENT_DIR"