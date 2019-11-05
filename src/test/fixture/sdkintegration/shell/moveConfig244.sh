#以下命令在244服务器执行
CURRENT_DIR=$PWD
rm -rf ../e2e-2Orgs/v1.3/*
#mkdir ../e2e-2Orgs/v1.3/crypto-config

cp -r crypto-config ../e2e-2Orgs/v1.3/
cp bar.tx ../e2e-2Orgs/v1.3/
cp foo.tx ../e2e-2Orgs/v1.3/
cp orderer.block ../e2e-2Orgs/v1.3/

rm -rf 1.3.zip 
zip -r 1.3.zip crypto-config/* bar.tx  foo.tx orderer.block
scp ../140.yaml 1.3.zip root@139.9.127.140:/data/code/java/fabric-1.4.0/fabric-sdk-java/src/test/fixture/sdkintegration/
cd "$CURRENT_DIR"
