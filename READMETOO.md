
## 步骤
以下步骤实现自定义域名，创建证书、创建创世区块，启动两台虚机运行fabric1.4.0网络，并执行End2endIT和NetworkConfigIT集成测试。

将139.9.120.244定义为master华为云虚机；139.9.127.140定义为slave华为云虚机。

### 1. 在master拉取fabric-sdk-java 
```shell
cd /data/code/java/fabric-1.4.0
git clone https://github.com/jiangyang118/fabric-sdk-java.git
cd fabric-sdk-java
git checkout manu-coinfig
cd  /data/code/java/fabric-1.4.0/fabric-sdk-java/src/test/fixture/sdkintegration

# 1.  创建证书
# 2.  创建创世区块
# 3.  修改运行的yaml文件中的配置
# 4.  发送到salve服务器
cd /data/code/java/fabric-1.4.0/fabric-sdk-java/src/test/fixture/sdkintegration/e2e-2Orgs
zip cry.zip  v1.3
scp cry.zip root@139.9.127.140:/data/code/java/fabric-1.4.0/fabric-sdk-java/src/test/fixture/sdkintegration/e2e-2Orgs
# 5.  启动网络，运行1个orderer；2个peer，1个ca；1个fabric-tools
docker-compose -f 244.yaml up -d

#日志如下
[root@ecs-1d88-0001 sdkintegration]# docker ps -a
CONTAINER ID        IMAGE                                                                                                         COMMAND                  CREATED             STATUS                      PORTS                    NAMES
723fbe7fbbca        hyperledger/fabric-peer:1.4                                                                                   "peer node start"        5 seconds ago       Up 3 seconds                0.0.0.0:7056->7056/tcp   peer1.org1.example.com
e1dd21938f1c        hyperledger/fabric-peer:1.4                                                                                   "peer node start"        5 seconds ago       Up 4 seconds                0.0.0.0:7051->7051/tcp   peer0.org1.example.com
656215da94b2        hyperledger/fabric-orderer:1.4                                                                                "orderer"                6 seconds ago       Up 4 seconds                0.0.0.0:7050->7050/tcp   orderer.example.com
06109ff827de        hyperledger/fabric-tools:1.4                                                                                  "/usr/local/bin/conf…"   6 seconds ago       Up 4 seconds                0.0.0.0:7059->7059/tcp   configtxlator
5b105fc22785        hyperledger/fabric-ca:1.4                                                                                     "sh -c 'mkdir -p /et…"   6 seconds ago       Up 4 seconds                0.0.0.0:7054->7054/tcp   ca_peerOrg1
```

### 2. 在slave拉取fabric-sdk-java 
```shell
cd /data/code/java/fabric-1.4.0
git clone https://github.com/jiangyang118/fabric-sdk-java.git
cd fabric-sdk-java
git checkout manu-coinfig
cd  /data/code/java/fabric-1.4.0/fabric-sdk-java/src/test/fixture/sdkintegration

# 1.  修改运行的yaml文件中的配置


# 2.  启动网络，运行1个orderer；2个peer，1个ca；1个fabric-tools
docker-compose -f 140.yaml up -d

#日志如下
[root@ecs-1d88-0002 sdkintegration]# docker ps -a
CONTAINER ID        IMAGE                                                                                                         COMMAND                  CREATED             STATUS                         PORTS                    NAMES
e03d13ab3963        hyperledger/fabric-peer:1.4                                                                                   "peer node start"        4 seconds ago       Up 3 seconds                   0.0.0.0:8056->8056/tcp   peer1.org2.example.com
39496142ce9d        hyperledger/fabric-peer:1.4                                                                                   "peer node start"        5 seconds ago       Up 4 seconds                   0.0.0.0:8051->8051/tcp   peer0.org2.example.com
cc1783271568        hyperledger/fabric-ca:1.4                                                                                     "sh -c 'mkdir -p /et…"   5 seconds ago       Up 4 seconds                   0.0.0.0:8054->7054/tcp   ca_peerOrg2
```

### 3. 在本地运行end2endIT单元测试
```shell

#手动替换如下路径的sk文件
#path: src/test/fixture/sdkintegration/e2e-2Orgs/v1.3/crypto-config/peerOrganizations/org1.esunego.com/users/Admin@org1.esunego.com/msp/keystore/8a48ddb8cb4cf9b376730f9f6bdb9d50dcc103b1cc9049c54f83db907849791a_sk
     
     
clean test -Dtest=End2endIT

#日志如下

-------------------------------------------------------
 T E S T S
-------------------------------------------------------
Running org.hyperledger.fabric.sdkintegration.End2endIT


Created channel foo
2019-11-04 08:09:31,090 main INFO  Channel:851 - Channel{id: 3, name: foo} joining Peer{ id: 5, name: peer1.org1.esunego.com, channelName: null, url: grpc://139.9.120.244:7056}.
2019-11-04 08:09:33,321 main INFO  Channel:883 - Peer Peer{ id: 5, name: peer1.org1.esunego.com, channelName: foo, url: grpc://139.9.120.244:7056} joined into channel Channel{id: 3, name: foo}
Peer peer1.org1.esunego.com joined channel foo
2019-11-04 08:09:33,327 main INFO  Channel:851 - Channel{id: 3, name: foo} joining Peer{ id: 8, name: peer0.org1.esunego.com, channelName: null, url: grpc://139.9.120.244:7051}.
2019-11-04 08:09:34,011 main INFO  Channel:883 - Peer Peer{ id: 8, name: peer0.org1.esunego.com, channelName: foo, url: grpc://139.9.120.244:7051} joined into channel Channel{id: 3, name: foo}
Peer peer0.org1.esunego.com joined channel foo
2019-11-04 08:09:36,427 main INFO  Channel:1259 - Channel Channel{id: 3, name: foo} eventThread started shutdown: false  thread: null 
Finished initialization channel foo
2019-11-04 08:09:36,750 pool-1-thread-1 INFO  Channel:5988 - Channel foo eventThread shutting down. shutdown: true  thread: pool-1-thread-1 
2019-11-04 08:09:38,764 main INFO  Channel:1259 - Channel Channel{id: 16, name: foo} eventThread started shutdown: false  thread: null 
Running channel foo
Creating install proposal
Sending install proposal
2019-11-04 08:10:43,480 main INFO  InstallProposalBuilder:243 - Installing 'example_cc_go::github.com/example_cc::1' language Go chaincode from directory: 'D:\code\java\fabric-sdk-java\src\test\fixture\sdkintegration\gocc\sample1\src\github.com\example_cc' with source location: 'src\github.com\example_cc'. chaincodePath:'github.com/example_cc'
Successful install proposal response Txid: 27dda32abaaab035464a7699804853ae2fd2e44c7f01ea4c00bc381b74d87680 from peer peer1.org1.esunego.com
Successful install proposal response Txid: 27dda32abaaab035464a7699804853ae2fd2e44c7f01ea4c00bc381b74d87680 from peer peer0.org1.esunego.com
Received 2 install proposal responses. Successful+verified: 2 . Failed: 0
Sending instantiateProposalRequest to all peers with arguments: a and b set to 100 and 200 respectively
Succesful instantiate proposal response Txid: 58124f6cceb0aa113496e0b26d99dfd35a003edc01bf990d1f855921d74b9569 from peer peer1.org1.esunego.com
Succesful instantiate proposal response Txid: 58124f6cceb0aa113496e0b26d99dfd35a003edc01bf990d1f855921d74b9569 from peer peer0.org1.esunego.com
Received 2 instantiate proposal responses. Successful+verified: 2 . Failed: 0
Sending instantiateTransaction to orderer with a and b set to 100 and 200 respectively
Finished instantiate transaction with transaction id 58124f6cceb0aa113496e0b26d99dfd35a003edc01bf990d1f855921d74b9569
sending transactionProposal to all peers with arguments: move(a,b,100)
Successful transaction proposal response Txid: 8d73e88abac11095eab3176a5b7a49c7a8d4063da8b8fbec2101f6ee0b2b33bb from peer peer1.org1.esunego.com
Successful transaction proposal response Txid: 8d73e88abac11095eab3176a5b7a49c7a8d4063da8b8fbec2101f6ee0b2b33bb from peer peer0.org1.esunego.com
Received 2 transaction proposal responses. Successful+verified: 2 . Failed: 0
Successfully received transaction proposal responses.
Sending chaincode transaction(move a,b,100) to orderer.
RECEIVED Chaincode event with handle: CHAINCODE_EVENTS_HANDLEb33d8b2e-2f54-40fc-b47b-eb2880877624CHAINCODE_EVENTS_HANDLE, chaincode Id: example_cc_go, chaincode event name: event, transaction id: 8d73e88abac11095eab3176a5b7a49c7a8d4063da8b8fbec2101f6ee0b2b33bb, event payload: "!", from event source: peer0.org1.esunego.com
RECEIVED Chaincode event with handle: CHAINCODE_EVENTS_HANDLEb33d8b2e-2f54-40fc-b47b-eb2880877624CHAINCODE_EVENTS_HANDLE, chaincode Id: example_cc_go, chaincode event name: event, transaction id: 8d73e88abac11095eab3176a5b7a49c7a8d4063da8b8fbec2101f6ee0b2b33bb, event payload: "!", from event source: peer1.org1.esunego.com
Finished transaction with transaction id 8d73e88abac11095eab3176a5b7a49c7a8d4063da8b8fbec2101f6ee0b2b33bb
Now query chaincode for the value of b.
Query payload of b from peer peer1.org1.esunego.com returned 300
Query payload of b from peer peer0.org1.esunego.com returned 300
Channel info for : foo
Channel height: 3
Chain current block hash: 34362236a65d5e88223894da5fa39b5b25b26184feed222930ffc9491de2487d
Chainl previous block hash: 58d6779e73e34f933ed83dcd84867993a5d91a7fcca5d8839c82fe28c09a70dc
queryBlockByNumber returned correct block with blockNumber 2 
 previous_hash 58d6779e73e34f933ed83dcd84867993a5d91a7fcca5d8839c82fe28c09a70dc
queryBlockByHash returned block with blockNumber 1
queryBlockByTxID returned block with blockNumber 2
QueryTransactionByID returned TransactionInfo: txID 8d73e88abac11095eab3176a5b7a49c7a8d4063da8b8fbec2101f6ee0b2b33bb
     validation code 0
Running for Channel foo done
2019-11-04 08:14:03,510 pool-1-thread-1 INFO  Channel:5988 - Channel foo eventThread shutting down. shutdown: true  thread: pool-1-thread-1 


Constructing channel bar
sdkintegration\e2e-2Orgs\v1.3\bar.tx
src\test\fixture\sdkintegration\e2e-2Orgs\v1.3\bar.tx
Created channel bar
2019-11-04 08:14:42,583 main INFO  Channel:851 - Channel{id: 31, name: bar} joining Peer{ id: 33, name: peer0.org2.esunego.com, channelName: null, url: grpc://139.9.127.140:8051}.
2019-11-04 08:14:44,499 main INFO  Channel:883 - Peer Peer{ id: 33, name: peer0.org2.esunego.com, channelName: bar, url: grpc://139.9.127.140:8051} joined into channel Channel{id: 31, name: bar}
Peer peer0.org2.esunego.com joined channel bar
2019-11-04 08:14:44,519 main INFO  Channel:851 - Channel{id: 31, name: bar} joining Peer{ id: 36, name: peer1.org2.esunego.com, channelName: null, url: grpc://139.9.127.140:8056}.
2019-11-04 08:14:46,359 main INFO  Channel:883 - Peer Peer{ id: 36, name: peer1.org2.esunego.com, channelName: bar, url: grpc://139.9.127.140:8056} joined into channel Channel{id: 31, name: bar}
Peer peer1.org2.esunego.com joined channel bar
2019-11-04 08:14:47,765 main INFO  Channel:1259 - Channel Channel{id: 31, name: bar} eventThread started shutdown: false  thread: null 
Finished initialization channel bar
2019-11-04 08:14:47,980 pool-1-thread-1 INFO  Channel:5988 - Channel bar eventThread shutting down. shutdown: true  thread: pool-1-thread-1 
2019-11-04 08:14:49,814 main INFO  Channel:1259 - Channel Channel{id: 44, name: bar} eventThread started shutdown: false  thread: null 
Running channel bar
Creating install proposal
Sending install proposal
2019-11-04 08:15:51,857 main INFO  InstallProposalBuilder:257 - Installing 'example_cc_go::github.com/example_cc::1'  Go chaincode chaincodePath:'github.com/example_cc' from input stream
Successful install proposal response Txid: eecaeaef963636ece00de0f747b82409d02cac896840f309b8b37356463d4a5b from peer peer0.org2.esunego.com
Successful install proposal response Txid: eecaeaef963636ece00de0f747b82409d02cac896840f309b8b37356463d4a5b from peer peer1.org2.esunego.com
Received 2 install proposal responses. Successful+verified: 2 . Failed: 0
Sending instantiateProposalRequest to all peers with arguments: a and b set to 100 and 300 respectively
Succesful instantiate proposal response Txid: fc776c805471049469cf6319b982c6370685edbcda0d7ee72b1f0b9538484b47 from peer peer0.org2.esunego.com
Succesful instantiate proposal response Txid: fc776c805471049469cf6319b982c6370685edbcda0d7ee72b1f0b9538484b47 from peer peer1.org2.esunego.com
Received 2 instantiate proposal responses. Successful+verified: 2 . Failed: 0
Sending instantiateTransaction to orderer with a and b set to 100 and 300 respectively
Finished instantiate transaction with transaction id fc776c805471049469cf6319b982c6370685edbcda0d7ee72b1f0b9538484b47
sending transactionProposal to all peers with arguments: move(a,b,100)
Successful transaction proposal response Txid: 7958375d6b532a77193946e9b7d0309d43c2842ee54dbd04bad559248794cef0 from peer peer0.org2.esunego.com
Successful transaction proposal response Txid: 7958375d6b532a77193946e9b7d0309d43c2842ee54dbd04bad559248794cef0 from peer peer1.org2.esunego.com
Received 2 transaction proposal responses. Successful+verified: 2 . Failed: 0
Successfully received transaction proposal responses.
Sending chaincode transaction(move a,b,100) to orderer.
Finished transaction with transaction id 7958375d6b532a77193946e9b7d0309d43c2842ee54dbd04bad559248794cef0
Now query chaincode for the value of b.
Query payload of b from peer peer0.org2.esunego.com returned 400
Query payload of b from peer peer1.org2.esunego.com returned 400
Channel info for : bar
Channel height: 3
Chain current block hash: cab837140997b069feaba320d452989b9ce0d840290fac062e3d2a2baa5227c0
Chainl previous block hash: 217bb1b2c2dfaf6eeb84ddbe534f019298097d65bd78ee975ca1376ce3f9362f
queryBlockByNumber returned correct block with blockNumber 2 
 previous_hash 217bb1b2c2dfaf6eeb84ddbe534f019298097d65bd78ee975ca1376ce3f9362f
queryBlockByHash returned block with blockNumber 1
queryBlockByTxID returned block with blockNumber 2
QueryTransactionByID returned TransactionInfo: txID 7958375d6b532a77193946e9b7d0309d43c2842ee54dbd04bad559248794cef0
     validation code 0
Running for Channel bar done

Traverse the blocks for chain bar 
current block number 2 has data hash: 7ed8f76c7aa8bbc3243ef7d70b97b7391552611aec86cc0744769d3d0d4e24aa
current block number 2 has previous hash id: 217bb1b2c2dfaf6eeb84ddbe534f019298097d65bd78ee975ca1376ce3f9362f
current block number 2 has calculated block hash is cab837140997b069feaba320d452989b9ce0d840290fac062e3d2a2baa5227c0
current block number 2 has 1 envelope count:
  Transaction number 1 has transaction id: 7958375d6b532a77193946e9b7d0309d43c2842ee54dbd04bad559248794cef0
  Transaction number 1 has channel id: bar
  Transaction number 1 has epoch: 0
  Transaction number 1 has transaction timestamp: 十一月 4,  2019  16:18:37 下午
  Transaction number 1 has type id: TRANSACTION_ENVELOPE
  Transaction number 1 has nonce : 0e992cfb0a72a6816e94db5081e6e02cac76e2a49cd7d0a8
  Transaction number 1 has submitter mspid: Org2MSP,  certificate: -----BEGIN CERTIFICATE-----
MIICjjCCAjWgAwIBAgIUPH3GOHONtQd1yPzkaCCwDZZrBxAwCgYIKoZIzj0EAwIw
czELMAkGA1UEBhMCVVMxEzARBgNVBAgTCkNhbGlmb3JuaWExFjAUBgNVBAcTDVNh
biBGcmFuY2lzY28xGTAXBgNVBAoTEG9yZzIuZXN1bmVnby5jb20xHDAaBgNVBAMT
E2NhLm9yZzIuZXN1bmVnby5jb20wHhcNMTkxMTA0MDgwNDAwWhcNMjAxMTAzMDgw
OTAwWjBCMTAwDQYDVQQLEwZjbGllbnQwCwYDVQQLEwRvcmcxMBIGA1UECxMLZGVw
YXJ0bWVudDExDjAMBgNVBAMTBXVzZXIxMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcD
QgAEJajam6EY/DF7oSAdUNAfZpzsP/WQLhoV8aK2wLg9uLcQOycKucT0Trt3DrRv
+4baX2tcRTMCtnnKNR9V2M5BmKOB1zCB1DAOBgNVHQ8BAf8EBAMCB4AwDAYDVR0T
AQH/BAIwADAdBgNVHQ4EFgQUbDgO848bsUxPZdS7LqsGPt8cFC8wKwYDVR0jBCQw
IoAgZHl6a+nTBbitUOTSCJ7ltHWgu/cNEVWHT0R/lfeFF/wwaAYIKgMEBQYHCAEE
XHsiYXR0cnMiOnsiaGYuQWZmaWxpYXRpb24iOiJvcmcxLmRlcGFydG1lbnQxIiwi
aGYuRW5yb2xsbWVudElEIjoidXNlcjEiLCJoZi5UeXBlIjoiY2xpZW50In19MAoG
CCqGSM49BAMCA0cAMEQCIAfv6aqkaPi3oJi6UJb+yn/dm3FlXO8yuk81D3mulA4x
AiBBjTBSvAMTT1VcoMYsmhVi4uYe/Pq1FHdKXqaqT9C8ZA==
-----END CERTIFICATE-----

  Transaction number 1 has 1 actions
  Transaction number 1 isValid true
  Transaction number 1 validation code 0
   Transaction action 1 has response status 179
   Transaction action 1 has response message bytes as string: 
   Transaction action 1 has 2 endorsements
Endorser 0 signature: 3044022035d1d7741f50a2f03d287b0bb80c9c0553498cda8504969726f612f49c52537e02203f2ca74bf236f20d3e52663ccc8d5df4a7113acf36d9f573a75d3996813b9aa7
Endorser 0 endorser: mspid Org2MSP 
 certificate -----BEGIN CERTIFICATE-----
MIICKDCCAc6gAwIBAgIQVItsizp+FnWSTxWp3vpRizAKBggqhkjOPQQDAjBzMQsw
CQYDVQQGEwJVUzETMBEGA1UECBMKQ2FsaWZvcm5pYTEWMBQGA1UEBxMNU2FuIEZy
YW5jaXNjbzEZMBcGA1UEChMQb3JnMi5lc3VuZWdvLmNvbTEcMBoGA1UEAxMTY2Eu
b3JnMi5lc3VuZWdvLmNvbTAeFw0xOTExMDIxNDIxMDBaFw0yOTEwMzAxNDIxMDBa
MGoxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpDYWxpZm9ybmlhMRYwFAYDVQQHEw1T
YW4gRnJhbmNpc2NvMQ0wCwYDVQQLEwRwZWVyMR8wHQYDVQQDExZwZWVyMC5vcmcy
LmVzdW5lZ28uY29tMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAE+ffClmR4zXgJ
HXpDqKqyXTM+A4b6mr/gQa+p8HT3NnETZiw8cnYM16v/cG73ExECBPWu+tTQuo0d
8WtVg/fZkKNNMEswDgYDVR0PAQH/BAQDAgeAMAwGA1UdEwEB/wQCMAAwKwYDVR0j
BCQwIoAgZHl6a+nTBbitUOTSCJ7ltHWgu/cNEVWHT0R/lfeFF/wwCgYIKoZIzj0E
AwIDSAAwRQIhAOuyYzbJmkTmjc2AgHM8TqIbMNz1I2jQU62UdfxjUP0qAiAWXQa+
I/xNIXO7PKShgc7z5whCdbeiR6DNWLdsS9UDbw==
-----END CERTIFICATE-----

Endorser 1 signature: 3044022033361ddb3ae53d7016f7ceb9e8081230d6cb8227a3ff596210e92c10981bb5a902207de9ddafb112e5300c899fed29fc8627a279e34cdc38ed523d9d601d5e7fbab2
Endorser 1 endorser: mspid Org2MSP 
 certificate -----BEGIN CERTIFICATE-----
MIICKDCCAc+gAwIBAgIRAKd7Ortw6lNi6RAfMm3fwAkwCgYIKoZIzj0EAwIwczEL
MAkGA1UEBhMCVVMxEzARBgNVBAgTCkNhbGlmb3JuaWExFjAUBgNVBAcTDVNhbiBG
cmFuY2lzY28xGTAXBgNVBAoTEG9yZzIuZXN1bmVnby5jb20xHDAaBgNVBAMTE2Nh
Lm9yZzIuZXN1bmVnby5jb20wHhcNMTkxMTAyMTQyMTAwWhcNMjkxMDMwMTQyMTAw
WjBqMQswCQYDVQQGEwJVUzETMBEGA1UECBMKQ2FsaWZvcm5pYTEWMBQGA1UEBxMN
U2FuIEZyYW5jaXNjbzENMAsGA1UECxMEcGVlcjEfMB0GA1UEAxMWcGVlcjEub3Jn
Mi5lc3VuZWdvLmNvbTBZMBMGByqGSM49AgEGCCqGSM49AwEHA0IABDjBZ5iCDThC
im9Xur5YYCRLFEFdPgeRRnekqzM8V+i10W5dtBZTEhdbgDDeY3qEHZQ3vQHxufqC
yJSXbLwvgm+jTTBLMA4GA1UdDwEB/wQEAwIHgDAMBgNVHRMBAf8EAjAAMCsGA1Ud
IwQkMCKAIGR5emvp0wW4rVDk0gie5bR1oLv3DRFVh09Ef5X3hRf8MAoGCCqGSM49
BAMCA0cAMEQCIBWz34zoqJNMaLk3FctxUig5Qk7PuYdVmnimu0tw0PMGAiB59riI
/Uxle8lQbuFEOrMVZc3ki639PKjZGx+iXoRj4g==
-----END CERTIFICATE-----

   Transaction action 1 has 4 chaincode input arguments
     Transaction action 1 has chaincode input argument 0 is: move
     Transaction action 1 has chaincode input argument 1 is: a
     Transaction action 1 has chaincode input argument 2 is: b
     Transaction action 1 has chaincode input argument 3 is: 100
   Transaction action 1 proposal response status: 179
   Transaction action 1 proposal response payload: :)
   Transaction action 1 proposal chaincodeIDName: example_cc_go, chaincodeIDVersion: 1
   Transaction action 1 has 2 name space read write sets
     Namespace example_cc_go read set 0 key a  version [1:0]
     Namespace example_cc_go read set 1 key b  version [1:0]
     Namespace example_cc_go write set 0 key a has value '400' 
     Namespace example_cc_go write set 1 key b has value '400' 
     Namespace lscc read set 0 key example_cc_go  version [1:0]
current block number 1 has data hash: db516ce08a1e170dcd4ec803572b59459066d5778303a670a0bdb1af19118c2d
current block number 1 has previous hash id: c7968e5a77a4c5fa8671baf2ee61c51dc92096dcd63a0eaa1ae894e6e1f1abb2
current block number 1 has calculated block hash is 217bb1b2c2dfaf6eeb84ddbe534f019298097d65bd78ee975ca1376ce3f9362f
current block number 1 has 1 envelope count:
  Transaction number 1 has transaction id: fc776c805471049469cf6319b982c6370685edbcda0d7ee72b1f0b9538484b47
  Transaction number 1 has channel id: bar
  Transaction number 1 has epoch: 0
  Transaction number 1 has transaction timestamp: 十一月 4,  2019  16:16:58 下午
  Transaction number 1 has type id: TRANSACTION_ENVELOPE
  Transaction number 1 has nonce : f01ff5a1ac1e6aab03200f64a7d27abc24dca8c028c19796
  Transaction number 1 has submitter mspid: Org2MSP,  certificate: -----BEGIN CERTIFICATE-----
MIICKjCCAdCgAwIBAgIRAIiZFJm+IQ2FhivPvc1bnFgwCgYIKoZIzj0EAwIwczEL
MAkGA1UEBhMCVVMxEzARBgNVBAgTCkNhbGlmb3JuaWExFjAUBgNVBAcTDVNhbiBG
cmFuY2lzY28xGTAXBgNVBAoTEG9yZzIuZXN1bmVnby5jb20xHDAaBgNVBAMTE2Nh
Lm9yZzIuZXN1bmVnby5jb20wHhcNMTkxMTAyMTQyMTAwWhcNMjkxMDMwMTQyMTAw
WjBrMQswCQYDVQQGEwJVUzETMBEGA1UECBMKQ2FsaWZvcm5pYTEWMBQGA1UEBxMN
U2FuIEZyYW5jaXNjbzEOMAwGA1UECxMFYWRtaW4xHzAdBgNVBAMMFkFkbWluQG9y
ZzIuZXN1bmVnby5jb20wWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAARAltd52kvv
ZPVWBCZm8p5S+7Li/+kNTzArXA2Aeu3jUpxl9Czh5etcF1k96LbNjU1MJylNb1R9
gt8me59wyv/ko00wSzAOBgNVHQ8BAf8EBAMCB4AwDAYDVR0TAQH/BAIwADArBgNV
HSMEJDAigCBkeXpr6dMFuK1Q5NIInuW0daC79w0RVYdPRH+V94UX/DAKBggqhkjO
PQQDAgNIADBFAiEAvUXkGLwapp+QkAgyWmclbtsfpIfPPMHpPXezTNbhKysCIDGT
e4t2A4ejNBw1zpgH+AYBDTeRsTynuurDdu+mpnVH
-----END CERTIFICATE-----

  Transaction number 1 has 1 actions
  Transaction number 1 isValid true
  Transaction number 1 validation code 0
   Transaction action 1 has response status 200
   Transaction action 1 has response message bytes as string: 
   Transaction action 1 has 2 endorsements
Endorser 0 signature: 3045022100b2b5e947fbe6ae4328ad0bfe6ad508859773800d710cff7e48a01c0e67a81e0b022051dca8d425c51ae4aaa92baf5c168b99f3204eb7bc098bfaa1f319b3214d99df
Endorser 0 endorser: mspid Org2MSP 
 certificate -----BEGIN CERTIFICATE-----
MIICKDCCAc6gAwIBAgIQVItsizp+FnWSTxWp3vpRizAKBggqhkjOPQQDAjBzMQsw
CQYDVQQGEwJVUzETMBEGA1UECBMKQ2FsaWZvcm5pYTEWMBQGA1UEBxMNU2FuIEZy
YW5jaXNjbzEZMBcGA1UEChMQb3JnMi5lc3VuZWdvLmNvbTEcMBoGA1UEAxMTY2Eu
b3JnMi5lc3VuZWdvLmNvbTAeFw0xOTExMDIxNDIxMDBaFw0yOTEwMzAxNDIxMDBa
MGoxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpDYWxpZm9ybmlhMRYwFAYDVQQHEw1T
YW4gRnJhbmNpc2NvMQ0wCwYDVQQLEwRwZWVyMR8wHQYDVQQDExZwZWVyMC5vcmcy
LmVzdW5lZ28uY29tMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAE+ffClmR4zXgJ
HXpDqKqyXTM+A4b6mr/gQa+p8HT3NnETZiw8cnYM16v/cG73ExECBPWu+tTQuo0d
8WtVg/fZkKNNMEswDgYDVR0PAQH/BAQDAgeAMAwGA1UdEwEB/wQCMAAwKwYDVR0j
BCQwIoAgZHl6a+nTBbitUOTSCJ7ltHWgu/cNEVWHT0R/lfeFF/wwCgYIKoZIzj0E
AwIDSAAwRQIhAOuyYzbJmkTmjc2AgHM8TqIbMNz1I2jQU62UdfxjUP0qAiAWXQa+
I/xNIXO7PKShgc7z5whCdbeiR6DNWLdsS9UDbw==
-----END CERTIFICATE-----

Endorser 1 signature: 3045022100fb2b0eac7a438215496ef29f121847900fafdc3305e84c5e8cb2df4b16b48ff402204411dc7f81db62aacc878d96733a518df0531ef03e2af79ca20fea1e62adc212
Endorser 1 endorser: mspid Org2MSP 
 certificate -----BEGIN CERTIFICATE-----
MIICKDCCAc+gAwIBAgIRAKd7Ortw6lNi6RAfMm3fwAkwCgYIKoZIzj0EAwIwczEL
MAkGA1UEBhMCVVMxEzARBgNVBAgTCkNhbGlmb3JuaWExFjAUBgNVBAcTDVNhbiBG
cmFuY2lzY28xGTAXBgNVBAoTEG9yZzIuZXN1bmVnby5jb20xHDAaBgNVBAMTE2Nh
Lm9yZzIuZXN1bmVnby5jb20wHhcNMTkxMTAyMTQyMTAwWhcNMjkxMDMwMTQyMTAw
WjBqMQswCQYDVQQGEwJVUzETMBEGA1UECBMKQ2FsaWZvcm5pYTEWMBQGA1UEBxMN
U2FuIEZyYW5jaXNjbzENMAsGA1UECxMEcGVlcjEfMB0GA1UEAxMWcGVlcjEub3Jn
Mi5lc3VuZWdvLmNvbTBZMBMGByqGSM49AgEGCCqGSM49AwEHA0IABDjBZ5iCDThC
im9Xur5YYCRLFEFdPgeRRnekqzM8V+i10W5dtBZTEhdbgDDeY3qEHZQ3vQHxufqC
yJSXbLwvgm+jTTBLMA4GA1UdDwEB/wQEAwIHgDAMBgNVHRMBAf8EAjAAMCsGA1Ud
IwQkMCKAIGR5emvp0wW4rVDk0gie5bR1oLv3DRFVh09Ef5X3hRf8MAoGCCqGSM49
BAMCA0cAMEQCIBWz34zoqJNMaLk3FctxUig5Qk7PuYdVmnimu0tw0PMGAiB59riI
/Uxle8lQbuFEOrMVZc3ki639PKjZGx+iXoRj4g==
-----END CERTIFICATE-----

   Transaction action 1 has 4 chaincode input arguments
     Transaction action 1 has chaincode input argument 0 is: deploy
     Transaction action 1 has chaincode input argument 1 is: bar
     Transaction action 1 has chaincode input argument 2 is: ?E???)??github.com/example_cc??example_cc_go??1????init??a??500?...
     Transaction action 1 has chaincode input argument 3 is: ? ??????????????????????????????????????Org1MSP??????Org2MSP????...
   Transaction action 1 proposal response status: 200
   Transaction action 1 proposal response payload: ??example_cc_go??1??escc"?vscc*Z? ??????????????????????????????...
   Transaction action 1 proposal chaincodeIDName: lscc, chaincodeIDVersion: 1.4.3
   Transaction action 1 has 2 name space read write sets
     Namespace example_cc_go write set 0 key a has value '500' 
     Namespace example_cc_go write set 1 key b has value '300' 
     Namespace lscc read set 0 key example_cc_go  version [0:0]
     Namespace lscc write set 0 key example_cc_go has value '??example_cc_go??1??escc"?vscc*Z? ??????????????????????????????...' 
current block number 0 has data hash: 0d09359c0f494f899ac144dd4d82d0e0085b1d583eb5b80b38788c96f68f0814
current block number 0 has previous hash id: 
current block number 0 has calculated block hash is c7968e5a77a4c5fa8671baf2ee61c51dc92096dcd63a0eaa1ae894e6e1f1abb2
current block number 0 has 1 envelope count:
  Transaction number 1 has transaction id: 
  Transaction number 1 has channel id: bar
  Transaction number 1 has epoch: 0
  Transaction number 1 has transaction timestamp: 十一月 4,  2019  16:14:39 下午
  Transaction number 1 has type id: ENVELOPE
  Transaction number 1 has nonce : 3b9fb9123acf2d200925712c861109c351629694c7ce6cb6
  Transaction number 1 has submitter mspid: OrdererMSP,  certificate: -----BEGIN CERTIFICATE-----
MIICHTCCAcSgAwIBAgIQCN3yt1Hjlch/Z28NZmYrpDAKBggqhkjOPQQDAjBpMQsw
CQYDVQQGEwJVUzETMBEGA1UECBMKQ2FsaWZvcm5pYTEWMBQGA1UEBxMNU2FuIEZy
YW5jaXNjbzEUMBIGA1UEChMLZXN1bmVnby5jb20xFzAVBgNVBAMTDmNhLmVzdW5l
Z28uY29tMB4XDTE5MTEwMjE0MjEwMFoXDTI5MTAzMDE0MjEwMFowajELMAkGA1UE
BhMCVVMxEzARBgNVBAgTCkNhbGlmb3JuaWExFjAUBgNVBAcTDVNhbiBGcmFuY2lz
Y28xEDAOBgNVBAsTB29yZGVyZXIxHDAaBgNVBAMTE29yZGVyZXIuZXN1bmVnby5j
b20wWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAATR3zABaT6hs48lpJzGkkcDv8GY
/NDYFbR/DgCvm5t4Kfn5ukzv9jiTWQqGzZqJ+4a9IGbM6vIV4TTh2va219MYo00w
SzAOBgNVHQ8BAf8EBAMCB4AwDAYDVR0TAQH/BAIwADArBgNVHSMEJDAigCDcSiqd
NKaeYpxF44kzo4dGhjzFdMQEo7nDXQLKjhuZ5DAKBggqhkjOPQQDAgNHADBEAiBv
UmnDSt5ssyCk3hb6YcI3glPgb3wsHam5jxuTFBIDfgIgC6FWxyox41YwzRB2LUnW
2REOEMxi5tV9X7HqQMtgRBo=
-----END CERTIFICATE-----

That's all folks!

```

### 4. 在本地运行NetworkConfigIT单元测试
```shell
clean test -Dtest=NetworkConfigIT

#日志如下

-------------------------------------------------------
 T E S T S
-------------------------------------------------------
Running org.hyperledger.fabric.sdkintegration.NetworkConfigIT




RUNNING: NetworkConfigIT.

2019-11-04 08:45:39,992 main INFO  HFCAClient:594 - CA Name: ca0, Version: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUNVRENDQWZlZ0F3SUJBZ0lRR3MrSEJlNUZWWEJjb3RPV0JzbkZFVEFLQmdncWhrak9QUVFEQWpCek1Rc3cKQ1FZRFZRUUdFd0pWVXpFVE1CRUdBMVVFQ0JNS1EyRnNhV1p2Y201cFlURVdNQlFHQTFVRUJ4TU5VMkZ1SUVaeQpZVzVqYVhOamJ6RVpNQmNHQTFVRUNoTVFiM0puTVM1bGMzVnVaV2R2TG1OdmJURWNNQm9HQTFVRUF4TVRZMkV1CmIzSm5NUzVsYzNWdVpXZHZMbU52YlRBZUZ3MHhPVEV4TURJeE5ESXhNREJhRncweU9URXdNekF4TkRJeE1EQmEKTUhNeEN6QUpCZ05WQkFZVEFsVlRNUk13RVFZRFZRUUlFd3BEWVd4cFptOXlibWxoTVJZd0ZBWURWUVFIRXcxVApZVzRnUm5KaGJtTnBjMk52TVJrd0Z3WURWUVFLRXhCdmNtY3hMbVZ6ZFc1bFoyOHVZMjl0TVJ3d0dnWURWUVFECkV4TmpZUzV2Y21jeExtVnpkVzVsWjI4dVkyOXRNRmt3RXdZSEtvWkl6ajBDQVFZSUtvWkl6ajBEQVFjRFFnQUUKVG8wR0Ivd1crS3ZESTZ0bHh0ZDRjOXJsanh0L2d0dHMyYTI2T01hMFVKeEJtblZvNytadkY3TVVOWjgvb3lxcgpYb0gwN2tOV1l1MGhrczJNRmxFamY2TnRNR3N3RGdZRFZSMFBBUUgvQkFRREFnR21NQjBHQTFVZEpRUVdNQlFHCkNDc0dBUVVGQndNQ0JnZ3JCZ0VGQlFjREFUQVBCZ05WSFJNQkFmOEVCVEFEQVFIL01Da0dBMVVkRGdRaUJDQ0UKRllteVhkdHh6UEFzenA5bFRBdDdKN0hXYXlkUlZaNG5GbmNJSXoxeC96QUtCZ2dxaGtqT1BRUURBZ05IQURCRQpBaUFzMGFuR2Rpb0RKQ2kxQ2NGZVlIYnorbE9TcXllUGZ6a3pxVTVUdmFUMDFnSWdiQkttVXE0WFIvYTUyQXI2ClhCcldtMHNVdVJZamt2MTkvWExRcVpaUEpCbz0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=, issuerPublicKey: CgJPVQoEUm9sZQoMRW5yb2xsbWVudElEChBSZXZvY2F0aW9uSGFuZGxlEkQKILkzRpZOfQ3oMK/8O2TVp54NeiHNrlGr2OyKd0MfOul+EiC6V5v6BuomsGIh+0bNU6MR4FLKrJPmIQPrbEPALgDJCBpECiBRyCaKduiODTKUmBKkOr5mvml4QlPuHcQkIsrQbBWKOBIgPXmPEj4X7IP7YkMuoH/ifER1b4UEn/jHmfX3zKaBFd8iRAogMMbDLvF2D5F6ZzLX2qjR09/TixRiRLQg/AX3obIZg0YSICbkpSpVrkQ7/91FYABtw0koQIBQVchykiRMDYVhobadIkQKIMADgWabzyirgO3c2/tQ/8uTSLO1RLebVEXbxe9FKAZmEiBogGbaLjapkZdYf1eZ07jyaObxaMzVmF616MabSWpK1yJECiBvYZbT7MPwrkaUthsplvUScmoCMO17Ltn+k7RDaFd0xBIguemzpx2tQQxetOCwYM9pzSe+UC+opnRXHHK77xj7JG4iRAognDJK1kXpb5PD6kSNzAr0qT44hKyOSfERqohmdFaYqVgSIHOYDT6LmmX6Eg11vkPHv1X1OuPILhFpnIiyGRYWgxp3KogBCiAInOGaHKaP7wxG1k3qiI8ibjG13Z8/1r9B5OjUzyO7LhIgJRV1y7l4O2Oj1YpX/8MEsqY29KprLDuwyIszra02b8waIJLGgydrcW+FI/P25jQioINBxAnPiKZpvYoc3Z6lYVr4IiAvaZHy2yJdBTsg6ezGI+5hwz+bX7eWQspGmQ2xpOFrAjJECiAalaiI0jjM8RtHOjjbZLs269j9V1eLOzJpF7zBa1eyzhIgs0tJQn31Z4uZu2lobhUXRdlZOMqc363eGsWGPKQbggE6RAog9+qGoJGPO7M888tlnYyPZKxqQecd8YXIBU4DkMXH5HQSII0lkif6hdRxvK+eMGE0tDeRqWrpVNuOKpgbtxi5OYgeQiDSPLDMOp1sUgceFzUg2ywGpYdh84fqMQQBQYRItsBcKEogG8RFO30KzMmV6t2MUY8B5BDjPxkLVEE09mo/yVZTQIRSIO/UtxP0PBRmOZXsn2gBLDStXa+WsNPfHc1N1x6sj89H, issuerRevocationPublicKey: LS0tLS1CRUdJTiBQVUJMSUMgS0VZLS0tLS0KTUhZd0VBWUhLb1pJemowQ0FRWUZLNEVFQUNJRFlnQUVyUTYwNmowaEw2TGVYaWIyN2ZBNUVsSzBkVjRkdEVHSwpYR2lmbDRpdWFPcEVpSmdxVkYyR2Y1cjdDbjJGK2lNR0tXMEplb2M0cU9nb1UvR212TXk4bmtWUHBabEhKKzl3CmQ0ZzFSVXY1NjNGMmdYN2Z5RlJFTlM1NFlMelNMZnR2Ci0tLS0tRU5EIFBVQkxJQyBLRVktLS0tLQo=
2019-11-04 08:45:40,599 main INFO  HFCAClient:594 - CA Name: ca0, Version: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUNVRENDQWZlZ0F3SUJBZ0lRR3MrSEJlNUZWWEJjb3RPV0JzbkZFVEFLQmdncWhrak9QUVFEQWpCek1Rc3cKQ1FZRFZRUUdFd0pWVXpFVE1CRUdBMVVFQ0JNS1EyRnNhV1p2Y201cFlURVdNQlFHQTFVRUJ4TU5VMkZ1SUVaeQpZVzVqYVhOamJ6RVpNQmNHQTFVRUNoTVFiM0puTVM1bGMzVnVaV2R2TG1OdmJURWNNQm9HQTFVRUF4TVRZMkV1CmIzSm5NUzVsYzNWdVpXZHZMbU52YlRBZUZ3MHhPVEV4TURJeE5ESXhNREJhRncweU9URXdNekF4TkRJeE1EQmEKTUhNeEN6QUpCZ05WQkFZVEFsVlRNUk13RVFZRFZRUUlFd3BEWVd4cFptOXlibWxoTVJZd0ZBWURWUVFIRXcxVApZVzRnUm5KaGJtTnBjMk52TVJrd0Z3WURWUVFLRXhCdmNtY3hMbVZ6ZFc1bFoyOHVZMjl0TVJ3d0dnWURWUVFECkV4TmpZUzV2Y21jeExtVnpkVzVsWjI4dVkyOXRNRmt3RXdZSEtvWkl6ajBDQVFZSUtvWkl6ajBEQVFjRFFnQUUKVG8wR0Ivd1crS3ZESTZ0bHh0ZDRjOXJsanh0L2d0dHMyYTI2T01hMFVKeEJtblZvNytadkY3TVVOWjgvb3lxcgpYb0gwN2tOV1l1MGhrczJNRmxFamY2TnRNR3N3RGdZRFZSMFBBUUgvQkFRREFnR21NQjBHQTFVZEpRUVdNQlFHCkNDc0dBUVVGQndNQ0JnZ3JCZ0VGQlFjREFUQVBCZ05WSFJNQkFmOEVCVEFEQVFIL01Da0dBMVVkRGdRaUJDQ0UKRllteVhkdHh6UEFzenA5bFRBdDdKN0hXYXlkUlZaNG5GbmNJSXoxeC96QUtCZ2dxaGtqT1BRUURBZ05IQURCRQpBaUFzMGFuR2Rpb0RKQ2kxQ2NGZVlIYnorbE9TcXllUGZ6a3pxVTVUdmFUMDFnSWdiQkttVXE0WFIvYTUyQXI2ClhCcldtMHNVdVJZamt2MTkvWExRcVpaUEpCbz0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=, issuerPublicKey: CgJPVQoEUm9sZQoMRW5yb2xsbWVudElEChBSZXZvY2F0aW9uSGFuZGxlEkQKILkzRpZOfQ3oMK/8O2TVp54NeiHNrlGr2OyKd0MfOul+EiC6V5v6BuomsGIh+0bNU6MR4FLKrJPmIQPrbEPALgDJCBpECiBRyCaKduiODTKUmBKkOr5mvml4QlPuHcQkIsrQbBWKOBIgPXmPEj4X7IP7YkMuoH/ifER1b4UEn/jHmfX3zKaBFd8iRAogMMbDLvF2D5F6ZzLX2qjR09/TixRiRLQg/AX3obIZg0YSICbkpSpVrkQ7/91FYABtw0koQIBQVchykiRMDYVhobadIkQKIMADgWabzyirgO3c2/tQ/8uTSLO1RLebVEXbxe9FKAZmEiBogGbaLjapkZdYf1eZ07jyaObxaMzVmF616MabSWpK1yJECiBvYZbT7MPwrkaUthsplvUScmoCMO17Ltn+k7RDaFd0xBIguemzpx2tQQxetOCwYM9pzSe+UC+opnRXHHK77xj7JG4iRAognDJK1kXpb5PD6kSNzAr0qT44hKyOSfERqohmdFaYqVgSIHOYDT6LmmX6Eg11vkPHv1X1OuPILhFpnIiyGRYWgxp3KogBCiAInOGaHKaP7wxG1k3qiI8ibjG13Z8/1r9B5OjUzyO7LhIgJRV1y7l4O2Oj1YpX/8MEsqY29KprLDuwyIszra02b8waIJLGgydrcW+FI/P25jQioINBxAnPiKZpvYoc3Z6lYVr4IiAvaZHy2yJdBTsg6ezGI+5hwz+bX7eWQspGmQ2xpOFrAjJECiAalaiI0jjM8RtHOjjbZLs269j9V1eLOzJpF7zBa1eyzhIgs0tJQn31Z4uZu2lobhUXRdlZOMqc363eGsWGPKQbggE6RAog9+qGoJGPO7M888tlnYyPZKxqQecd8YXIBU4DkMXH5HQSII0lkif6hdRxvK+eMGE0tDeRqWrpVNuOKpgbtxi5OYgeQiDSPLDMOp1sUgceFzUg2ywGpYdh84fqMQQBQYRItsBcKEogG8RFO30KzMmV6t2MUY8B5BDjPxkLVEE09mo/yVZTQIRSIO/UtxP0PBRmOZXsn2gBLDStXa+WsNPfHc1N1x6sj89H, issuerRevocationPublicKey: LS0tLS1CRUdJTiBQVUJMSUMgS0VZLS0tLS0KTUhZd0VBWUhLb1pJemowQ0FRWUZLNEVFQUNJRFlnQUVyUTYwNmowaEw2TGVYaWIyN2ZBNUVsSzBkVjRkdEVHSwpYR2lmbDRpdWFPcEVpSmdxVkYyR2Y1cjdDbjJGK2lNR0tXMEplb2M0cU9nb1UvR212TXk4bmtWUHBabEhKKzl3CmQ0ZzFSVXY1NjNGMmdYN2Z5RlJFTlM1NFlMelNMZnR2Ci0tLS0tRU5EIFBVQkxJQyBLRVktLS0tLQo=
2019-11-04 08:45:40,599 main INFO  HFCAClient:1542 - CA Version: 1.4.3
2019-11-04 08:45:41,137 main INFO  HFCAClient:594 - CA Name: , Version: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUNVVENDQWZpZ0F3SUJBZ0lSQUtMMGRNWHdQU0JTNkNzNS9YdVdyWWt3Q2dZSUtvWkl6ajBFQXdJd2N6RUwKTUFrR0ExVUVCaE1DVlZNeEV6QVJCZ05WQkFnVENrTmhiR2xtYjNKdWFXRXhGakFVQmdOVkJBY1REVk5oYmlCRwpjbUZ1WTJselkyOHhHVEFYQmdOVkJBb1RFRzl5WnpJdVpYTjFibVZuYnk1amIyMHhIREFhQmdOVkJBTVRFMk5oCkxtOXlaekl1WlhOMWJtVm5ieTVqYjIwd0hoY05NVGt4TVRBeU1UUXlNVEF3V2hjTk1qa3hNRE13TVRReU1UQXcKV2pCek1Rc3dDUVlEVlFRR0V3SlZVekVUTUJFR0ExVUVDQk1LUTJGc2FXWnZjbTVwWVRFV01CUUdBMVVFQnhNTgpVMkZ1SUVaeVlXNWphWE5qYnpFWk1CY0dBMVVFQ2hNUWIzSm5NaTVsYzNWdVpXZHZMbU52YlRFY01Cb0dBMVVFCkF4TVRZMkV1YjNKbk1pNWxjM1Z1WldkdkxtTnZiVEJaTUJNR0J5cUdTTTQ5QWdFR0NDcUdTTTQ5QXdFSEEwSUEKQlBma3pVM0E2eDMzQTFyem9Fb3VTVjhmdUJyRU9kblhobGJKdUJIcm1qNXlsbmFzL1RLWXR3THQ2V1dTekdsMwoxSm5iYXV0Mldxa0VlMUVsS2crQTV4U2piVEJyTUE0R0ExVWREd0VCL3dRRUF3SUJwakFkQmdOVkhTVUVGakFVCkJnZ3JCZ0VGQlFjREFnWUlLd1lCQlFVSEF3RXdEd1lEVlIwVEFRSC9CQVV3QXdFQi96QXBCZ05WSFE0RUlnUWcKWkhsNmErblRCYml0VU9UU0NKN2x0SFdndS9jTkVWV0hUMFIvbGZlRkYvd3dDZ1lJS29aSXpqMEVBd0lEUndBdwpSQUlnT2ZTcGRsWmY1eVhGa1hySlFPT0F0R2xtRWxPclRvMm9pQVhNVnczQkZkNENJQVljWjhVeEs3YUo3UmdQCjJjei9uUVRDZWsvZ1k1Z1p6NXpTNjBtc0xScHEKLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=, issuerPublicKey: CgJPVQoEUm9sZQoMRW5yb2xsbWVudElEChBSZXZvY2F0aW9uSGFuZGxlEkQKIG5Ux1pOGqdhxdZNXXMLTgjhn+9RjjbT6MQE9ST63s0IEiBO+nvhC7NBJtaRzDiQ0hrlipfqUP6uf0z6HgUd2L9x0xpECiByC2wbbF578jlkHX82sR+4FeAjQ7nbTiUQpjmmbqWE9xIgr/VguRnC4ZPM2owgCsLj/npmzXUDtwJb7+bH1uQ2sxsiRAogG15xhAeI8WRTQvXaG/BpUxvWU+LAvqS2+kbkhY9GMKoSICd6old9vBj0csnBNl0WG+hlhoExYjabZRCpipdL1brpIkQKIKrC2JKZk4NnxICmcOkQ3R37dwvc7RUhTb5kJgyjXdirEiCpuLrX+lThe3IYIiFO9SeZhJIUSvI8RqNUdNaGlUZmtCJECiBq2x37CEK1C5kzcqo/HKaJ3FPlkMS9sLv8epd7rDW00xIgotZFwKD/y6+mBahnM/rGKw7aMT4r/PQxl7cONo6vM5ciRAogZIjy9X2eIO9YjTHZsWW8jn9nv0BR0QWDnWoY3l9jKVsSIAxylDIS10iq/tUlXpSTllVo22DwGsQ7wwORPBr0DhoDKogBCiC3jSYjtP8VrXgtqZ6ADTJjpWz2HSg09thTRhhO45JfnhIgyp1wlQsJPGeJOxCFfXgWCw8YQ18hjNOhF8a+xBvG8PgaIAD0HUvs66/1/PlI1j0zCaj/2v+XVRRHaatRubfygqs4IiC8Gok5ZvCUwMD/psolXzmUDmB7YPZh1nr9jZwmScBs7jJECiCa+anLdJjYNyTesIaDj2A1W5GH1S/9Cf0Mo+R2dw6F1BIgQR4NdVpu4qOiDztDcZGiNK9K8csCYiowCw3/wQechqk6RAogZLvHGDzQMI7rg4fnCz7ucWIxx3sO/kK8pc5qdZBjP2ISIJabbIOfRdC2TCmGlKkJwnR/nNXkW7YkNXjbBZOIB4oHQiAWNcuepx/SIDAE/QGVhGzGZz7kQYcV51vOsCCmic53hUogDf4oj5DVox6CiCe+oD5JrceUgC7h2Rb9jlgLbeWtooBSIKcaZ2Ls/dqcgC+h4/qSVzKfcfnmDyPAiE5YP32OWqYh, issuerRevocationPublicKey: LS0tLS1CRUdJTiBQVUJMSUMgS0VZLS0tLS0KTUhZd0VBWUhLb1pJemowQ0FRWUZLNEVFQUNJRFlnQUVFSGFwdmJRcGNHbm04VTUzM0prY2pSZk9HTXBJaEJ5NQpWbFA3b29XM0RXWU5tRVlmR3pWSXBTZ1Rhb3ZoYzI4ZlcwT1Q0K05Dclh5S0hjakZtWGh4Z0xxaktKTHdlZUl6CmJpVElJRWlXVTJNcXkzY0dNMGlkalpSbFNtTmk0UGx3Ci0tLS0tRU5EIFBVQkxJQyBLRVktLS0tLQo=
2019-11-04 08:45:41,514 main INFO  HFCAClient:594 - CA Name: , Version: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUNVVENDQWZpZ0F3SUJBZ0lSQUtMMGRNWHdQU0JTNkNzNS9YdVdyWWt3Q2dZSUtvWkl6ajBFQXdJd2N6RUwKTUFrR0ExVUVCaE1DVlZNeEV6QVJCZ05WQkFnVENrTmhiR2xtYjNKdWFXRXhGakFVQmdOVkJBY1REVk5oYmlCRwpjbUZ1WTJselkyOHhHVEFYQmdOVkJBb1RFRzl5WnpJdVpYTjFibVZuYnk1amIyMHhIREFhQmdOVkJBTVRFMk5oCkxtOXlaekl1WlhOMWJtVm5ieTVqYjIwd0hoY05NVGt4TVRBeU1UUXlNVEF3V2hjTk1qa3hNRE13TVRReU1UQXcKV2pCek1Rc3dDUVlEVlFRR0V3SlZVekVUTUJFR0ExVUVDQk1LUTJGc2FXWnZjbTVwWVRFV01CUUdBMVVFQnhNTgpVMkZ1SUVaeVlXNWphWE5qYnpFWk1CY0dBMVVFQ2hNUWIzSm5NaTVsYzNWdVpXZHZMbU52YlRFY01Cb0dBMVVFCkF4TVRZMkV1YjNKbk1pNWxjM1Z1WldkdkxtTnZiVEJaTUJNR0J5cUdTTTQ5QWdFR0NDcUdTTTQ5QXdFSEEwSUEKQlBma3pVM0E2eDMzQTFyem9Fb3VTVjhmdUJyRU9kblhobGJKdUJIcm1qNXlsbmFzL1RLWXR3THQ2V1dTekdsMwoxSm5iYXV0Mldxa0VlMUVsS2crQTV4U2piVEJyTUE0R0ExVWREd0VCL3dRRUF3SUJwakFkQmdOVkhTVUVGakFVCkJnZ3JCZ0VGQlFjREFnWUlLd1lCQlFVSEF3RXdEd1lEVlIwVEFRSC9CQVV3QXdFQi96QXBCZ05WSFE0RUlnUWcKWkhsNmErblRCYml0VU9UU0NKN2x0SFdndS9jTkVWV0hUMFIvbGZlRkYvd3dDZ1lJS29aSXpqMEVBd0lEUndBdwpSQUlnT2ZTcGRsWmY1eVhGa1hySlFPT0F0R2xtRWxPclRvMm9pQVhNVnczQkZkNENJQVljWjhVeEs3YUo3UmdQCjJjei9uUVRDZWsvZ1k1Z1p6NXpTNjBtc0xScHEKLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=, issuerPublicKey: CgJPVQoEUm9sZQoMRW5yb2xsbWVudElEChBSZXZvY2F0aW9uSGFuZGxlEkQKIG5Ux1pOGqdhxdZNXXMLTgjhn+9RjjbT6MQE9ST63s0IEiBO+nvhC7NBJtaRzDiQ0hrlipfqUP6uf0z6HgUd2L9x0xpECiByC2wbbF578jlkHX82sR+4FeAjQ7nbTiUQpjmmbqWE9xIgr/VguRnC4ZPM2owgCsLj/npmzXUDtwJb7+bH1uQ2sxsiRAogG15xhAeI8WRTQvXaG/BpUxvWU+LAvqS2+kbkhY9GMKoSICd6old9vBj0csnBNl0WG+hlhoExYjabZRCpipdL1brpIkQKIKrC2JKZk4NnxICmcOkQ3R37dwvc7RUhTb5kJgyjXdirEiCpuLrX+lThe3IYIiFO9SeZhJIUSvI8RqNUdNaGlUZmtCJECiBq2x37CEK1C5kzcqo/HKaJ3FPlkMS9sLv8epd7rDW00xIgotZFwKD/y6+mBahnM/rGKw7aMT4r/PQxl7cONo6vM5ciRAogZIjy9X2eIO9YjTHZsWW8jn9nv0BR0QWDnWoY3l9jKVsSIAxylDIS10iq/tUlXpSTllVo22DwGsQ7wwORPBr0DhoDKogBCiC3jSYjtP8VrXgtqZ6ADTJjpWz2HSg09thTRhhO45JfnhIgyp1wlQsJPGeJOxCFfXgWCw8YQ18hjNOhF8a+xBvG8PgaIAD0HUvs66/1/PlI1j0zCaj/2v+XVRRHaatRubfygqs4IiC8Gok5ZvCUwMD/psolXzmUDmB7YPZh1nr9jZwmScBs7jJECiCa+anLdJjYNyTesIaDj2A1W5GH1S/9Cf0Mo+R2dw6F1BIgQR4NdVpu4qOiDztDcZGiNK9K8csCYiowCw3/wQechqk6RAogZLvHGDzQMI7rg4fnCz7ucWIxx3sO/kK8pc5qdZBjP2ISIJabbIOfRdC2TCmGlKkJwnR/nNXkW7YkNXjbBZOIB4oHQiAWNcuepx/SIDAE/QGVhGzGZz7kQYcV51vOsCCmic53hUogDf4oj5DVox6CiCe+oD5JrceUgC7h2Rb9jlgLbeWtooBSIKcaZ2Ls/dqcgC+h4/qSVzKfcfnmDyPAiE5YP32OWqYh, issuerRevocationPublicKey: LS0tLS1CRUdJTiBQVUJMSUMgS0VZLS0tLS0KTUhZd0VBWUhLb1pJemowQ0FRWUZLNEVFQUNJRFlnQUVFSGFwdmJRcGNHbm04VTUzM0prY2pSZk9HTXBJaEJ5NQpWbFA3b29XM0RXWU5tRVlmR3pWSXBTZ1Rhb3ZoYzI4ZlcwT1Q0K05Dclh5S0hjakZtWGh4Z0xxaktKTHdlZUl6CmJpVElJRWlXVTJNcXkzY0dNMGlkalpSbFNtTmk0UGx3Ci0tLS0tRU5EIFBVQkxJQyBLRVktLS0tLQo=
2019-11-04 08:45:41,514 main INFO  HFCAClient:1542 - CA Version: 1.4.3
org.hyperledger.fabric.sdk.NetworkConfig@48b67364
2019-11-04 08:45:46,776 main INFO  Channel:1259 - Channel Channel{id: 1, name: foo} eventThread started shutdown: false  thread: null 
Checking instantiated chaincode: cc-NetworkConfigTest-001, at version: 1, on peer: peer0.org1.esunego.com
2019-11-04 08:45:47,692 main INFO  Channel:1259 - Channel Channel{id: 8, name: foo} eventThread started shutdown: false  thread: null 
Running testUpdate1 - Channel foo
Now query chaincode on channel foo for the current value of b
Query payload of b from peer peer0.org1.esunego.com returned 999
Query payload of b from peer peer1.org1.esunego.com returned 999
Original value = 999
sending transaction proposal to all peers with arguments: move(a,b,5)
Successful transaction proposal response Txid: 6537e619ea878c341af0eacd346ae262625fcb25a1de57bd9bae02084a124fa2 from peer peer0.org1.esunego.com
Successful transaction proposal response Txid: 6537e619ea878c341af0eacd346ae262625fcb25a1de57bd9bae02084a124fa2 from peer peer1.org1.esunego.com
Received 2 transaction proposal responses. Successful+verified: 2 . Failed: 0
Successfully received transaction proposal responses.
Sending chaincode transaction(move a,b,5) to orderer.
Now query chaincode on channel foo for the value of b expecting to see: 1004
Now query chaincode on channel foo for the current value of b
Query payload of b from peer peer0.org1.esunego.com returned 1004
Query payload of b from peer peer1.org1.esunego.com returned 1004
sending transaction proposal to all peers with arguments: move(b,a,5)
Successful transaction proposal response Txid: 315febec1dc28c2725b7f63e103bd4c843f80f53d05dc5f6774629851dfd810f from peer peer0.org1.esunego.com
Successful transaction proposal response Txid: 315febec1dc28c2725b7f63e103bd4c843f80f53d05dc5f6774629851dfd810f from peer peer1.org1.esunego.com
Received 2 transaction proposal responses. Successful+verified: 2 . Failed: 0
Successfully received transaction proposal responses.
Sending chaincode transaction(move b,a,5) to orderer.
Now query chaincode on channel foo for the value of b expecting to see: 999
Now query chaincode on channel foo for the current value of b
Query payload of b from peer peer0.org1.esunego.com returned 999
Query payload of b from peer peer1.org1.esunego.com returned 999
testUpdate1 - done
That's all folks!
2019-11-04 08:45:52,619 pool-3-thread-1 INFO  Channel:5988 - Channel foo eventThread shutting down. shutdown: true  thread: pool-3-thread-1 


```

### 5. 停止master和slave机器上的docker
```shell
#停止命令
docker-compose down
```
