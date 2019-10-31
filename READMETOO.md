
## 步骤

将139.9.120.244定义为master华为云虚机；139.9.127.140定义为slave华为云虚机。

### 1. 在master拉取fabric-sdk-java 
```shell
cd /data/code/java/fabric-1.4.0
git clone https://github.com/jiangyang118/fabric-sdk-java.git
cd fabric-sdk-java
git checkout multi-solo
cd  /data/code/java/fabric-1.4.0/fabric-sdk-java/src/test/fixture/sdkintegration
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
git checkout multi-solo
cd  /data/code/java/fabric-1.4.0/fabric-sdk-java/src/test/fixture/sdkintegration
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
clean test -Dtest=End2endIT

#日志如下

-------------------------------------------------------
 T E S T S
-------------------------------------------------------
Running org.hyperledger.fabric.sdkintegration.End2endIT



RUNNING: End2endIT.

***** Enrolling Users *****
2019-10-31 08:32:12,750 main INFO  HFCAClient:594 - CA Name: ca0, Version: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUNRekNDQWVxZ0F3SUJBZ0lSQU0vdmFEdlBzeUlpQzlodm41bm5SOEF3Q2dZSUtvWkl6ajBFQXdJd2N6RUwKTUFrR0ExVUVCaE1DVlZNeEV6QVJCZ05WQkFnVENrTmhiR2xtYjNKdWFXRXhGakFVQmdOVkJBY1REVk5oYmlCRwpjbUZ1WTJselkyOHhHVEFYQmdOVkJBb1RFRzl5WnpFdVpYaGhiWEJzWlM1amIyMHhIREFhQmdOVkJBTVRFMk5oCkxtOXlaekV1WlhoaGJYQnNaUzVqYjIwd0hoY05NVGd3TWpJMU1USTBNekk1V2hjTk1qZ3dNakl6TVRJME16STUKV2pCek1Rc3dDUVlEVlFRR0V3SlZVekVUTUJFR0ExVUVDQk1LUTJGc2FXWnZjbTVwWVRFV01CUUdBMVVFQnhNTgpVMkZ1SUVaeVlXNWphWE5qYnpFWk1CY0dBMVVFQ2hNUWIzSm5NUzVsZUdGdGNHeGxMbU52YlRFY01Cb0dBMVVFCkF4TVRZMkV1YjNKbk1TNWxlR0Z0Y0d4bExtTnZiVEJaTUJNR0J5cUdTTTQ5QWdFR0NDcUdTTTQ5QXdFSEEwSUEKQkxxSTlkWDdkOU5HbzNndUw1RlA4b3RHc2lCak43QnpkNmRHL0NheUpEZmpOUkczNFlPOHQyOTl1NkVvRlh2egpwY2pBTUd1MFVLVHJ6TWZjeU91emNNeWpYekJkTUE0R0ExVWREd0VCL3dRRUF3SUJwakFQQmdOVkhTVUVDREFHCkJnUlZIU1VBTUE4R0ExVWRFd0VCL3dRRk1BTUJBZjh3S1FZRFZSME9CQ0lFSUxITU5NUHkwTStBZUdqNk9ob1IKaDAwZ1FUQ0VYOWp1czIwdVdVVFhkbmNjTUFvR0NDcUdTTTQ5QkFNQ0EwY0FNRVFDSUY3V2wzQTExekVOcjFDbwpxR3l1M2g0ZkN1a2t0RlZ5Ry9XUEpVeWxWWGpJQWlCOUxqcFhtOUVSZ0pNZlpzakRJekNqOU00YVF1Vk45WExrClhueDB1b0t6N2c9PQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==, issuerPublicKey: CgJPVQoEUm9sZQoMRW5yb2xsbWVudElEChBSZXZvY2F0aW9uSGFuZGxlEkQKIDwI9XgGar29lWsgJQ5P++7nzIIlwWWGLEJ51ykde2A1EiCqCseWTnj4fux5l9ozepRqBhlZDfRZQFOKy755TIRikhpECiBvNt5Wcruon1yTI2OEtyActT1S0GLFcfCWXRMFykliiBIgL2P8/HJvbEI5pLb0LgoTUA1JDYYS+/MKC5irpY6t25wiRAogCAVRXVLX9SAwPD64Io0XEBFzpU0AOLnlUO84CJEN/XMSINGlHg7UFotyrB8gssFv3O56azHl+2X+k0nC2fS4IJY7IkQKILXIuSKsaLPOEnzyALvLpiW5rwRrAZZGHtkGx4CDUyY3EiDTMRCTEROrAXB/ZINA+RP3FzeUgnDLxLOes+OubkOQIyJECiA0wS8aoljJ6XkaAm6viC3+OY1WhN+zlEgfckCrIeFzixIgOKoxJtgZrFma+LPjLye6/RYlejeNegmSePueBMhOctYiRAogP3UpF6MJUiwgP1WAEdcEUmA1qBzM/pnh/P4DvTClVNsSII0ME/JUvx2G/KanqXhHSdiOPO8JMvl/oT9j86NE5acMKogBCiAkGHyPPIpfZ62j37rU+vuyhyVn3GTzHxzfENb4L81d9hIg4lovQafbr+EQ8oOgJNQYJTNoxrwt03gX0KoS351tA9AaIAprAFVW8Rj/oz5qv8EgezttuHVW6CeYxhClVaUXgkv8IiCB5IQt3kHBcfaLZ0G6T07NcgX0yEcLq/SCjjIzC+OMITJECiBjX+SptFK5yiKrp6p2unJEQzicZrOl7pcjQaYCRscHxBIgNa9BFzQiJmywsmJlMcjSexW66XrrJZzTGZIGjeuiobU6RAogiyMMfc2QIHR94xmd+qIfFFeu8C0G3x/as3asLSH63YcSIEPbCHzdb/sMxS5h42sPx+bhLbJ0UzYMapdOKilxyluFQiC+JXB0Nrg+JUDkXOO30VuNa1OWTaY+uui66lvI59+s/EogS5zQNR8QLbjptQUWittI672tran5xUvtidx7QeTSjQVSIHRZz7ANrFN/racCNVLnIrCqzxKU+QGje3+AuKvFasmy, issuerRevocationPublicKey: LS0tLS1CRUdJTiBQVUJMSUMgS0VZLS0tLS0KTUhZd0VBWUhLb1pJemowQ0FRWUZLNEVFQUNJRFlnQUVVeWpzYmtvL2kxSUg0ZEEvOURBeE15RW9YUFczVTRJRQpaMUh2K0VmWXhka1IrWWRLdzVYb09BeGRvVnl0blUzZzJNTStTZ01XK1QyZnZNVHQxOHR3QkVITVRQZnE1VHBoCmZ1VExVaitvSVJFbEFXSkNsOW44cTVRcWFLWjZaekNlCi0tLS0tRU5EIFBVQkxJQyBLRVktLS0tLQo=
2019-10-31 08:32:12,760 main INFO  SampleStore:91 - Could not find the file "C:\Users\jiang\AppData\Local\Temp\HFCSampletest.properties"
2019-10-31 08:32:12,765 main INFO  SampleStore:91 - Could not find the file "C:\Users\jiang\AppData\Local\Temp\HFCSampletest.properties"
2019-10-31 08:32:13,763 main INFO  HFCAClient:594 - CA Name: ca0, Version: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUNRekNDQWVxZ0F3SUJBZ0lSQU0vdmFEdlBzeUlpQzlodm41bm5SOEF3Q2dZSUtvWkl6ajBFQXdJd2N6RUwKTUFrR0ExVUVCaE1DVlZNeEV6QVJCZ05WQkFnVENrTmhiR2xtYjNKdWFXRXhGakFVQmdOVkJBY1REVk5oYmlCRwpjbUZ1WTJselkyOHhHVEFYQmdOVkJBb1RFRzl5WnpFdVpYaGhiWEJzWlM1amIyMHhIREFhQmdOVkJBTVRFMk5oCkxtOXlaekV1WlhoaGJYQnNaUzVqYjIwd0hoY05NVGd3TWpJMU1USTBNekk1V2hjTk1qZ3dNakl6TVRJME16STUKV2pCek1Rc3dDUVlEVlFRR0V3SlZVekVUTUJFR0ExVUVDQk1LUTJGc2FXWnZjbTVwWVRFV01CUUdBMVVFQnhNTgpVMkZ1SUVaeVlXNWphWE5qYnpFWk1CY0dBMVVFQ2hNUWIzSm5NUzVsZUdGdGNHeGxMbU52YlRFY01Cb0dBMVVFCkF4TVRZMkV1YjNKbk1TNWxlR0Z0Y0d4bExtTnZiVEJaTUJNR0J5cUdTTTQ5QWdFR0NDcUdTTTQ5QXdFSEEwSUEKQkxxSTlkWDdkOU5HbzNndUw1RlA4b3RHc2lCak43QnpkNmRHL0NheUpEZmpOUkczNFlPOHQyOTl1NkVvRlh2egpwY2pBTUd1MFVLVHJ6TWZjeU91emNNeWpYekJkTUE0R0ExVWREd0VCL3dRRUF3SUJwakFQQmdOVkhTVUVDREFHCkJnUlZIU1VBTUE4R0ExVWRFd0VCL3dRRk1BTUJBZjh3S1FZRFZSME9CQ0lFSUxITU5NUHkwTStBZUdqNk9ob1IKaDAwZ1FUQ0VYOWp1czIwdVdVVFhkbmNjTUFvR0NDcUdTTTQ5QkFNQ0EwY0FNRVFDSUY3V2wzQTExekVOcjFDbwpxR3l1M2g0ZkN1a2t0RlZ5Ry9XUEpVeWxWWGpJQWlCOUxqcFhtOUVSZ0pNZlpzakRJekNqOU00YVF1Vk45WExrClhueDB1b0t6N2c9PQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==, issuerPublicKey: CgJPVQoEUm9sZQoMRW5yb2xsbWVudElEChBSZXZvY2F0aW9uSGFuZGxlEkQKIDwI9XgGar29lWsgJQ5P++7nzIIlwWWGLEJ51ykde2A1EiCqCseWTnj4fux5l9ozepRqBhlZDfRZQFOKy755TIRikhpECiBvNt5Wcruon1yTI2OEtyActT1S0GLFcfCWXRMFykliiBIgL2P8/HJvbEI5pLb0LgoTUA1JDYYS+/MKC5irpY6t25wiRAogCAVRXVLX9SAwPD64Io0XEBFzpU0AOLnlUO84CJEN/XMSINGlHg7UFotyrB8gssFv3O56azHl+2X+k0nC2fS4IJY7IkQKILXIuSKsaLPOEnzyALvLpiW5rwRrAZZGHtkGx4CDUyY3EiDTMRCTEROrAXB/ZINA+RP3FzeUgnDLxLOes+OubkOQIyJECiA0wS8aoljJ6XkaAm6viC3+OY1WhN+zlEgfckCrIeFzixIgOKoxJtgZrFma+LPjLye6/RYlejeNegmSePueBMhOctYiRAogP3UpF6MJUiwgP1WAEdcEUmA1qBzM/pnh/P4DvTClVNsSII0ME/JUvx2G/KanqXhHSdiOPO8JMvl/oT9j86NE5acMKogBCiAkGHyPPIpfZ62j37rU+vuyhyVn3GTzHxzfENb4L81d9hIg4lovQafbr+EQ8oOgJNQYJTNoxrwt03gX0KoS351tA9AaIAprAFVW8Rj/oz5qv8EgezttuHVW6CeYxhClVaUXgkv8IiCB5IQt3kHBcfaLZ0G6T07NcgX0yEcLq/SCjjIzC+OMITJECiBjX+SptFK5yiKrp6p2unJEQzicZrOl7pcjQaYCRscHxBIgNa9BFzQiJmywsmJlMcjSexW66XrrJZzTGZIGjeuiobU6RAogiyMMfc2QIHR94xmd+qIfFFeu8C0G3x/as3asLSH63YcSIEPbCHzdb/sMxS5h42sPx+bhLbJ0UzYMapdOKilxyluFQiC+JXB0Nrg+JUDkXOO30VuNa1OWTaY+uui66lvI59+s/EogS5zQNR8QLbjptQUWittI672tran5xUvtidx7QeTSjQVSIHRZz7ANrFN/racCNVLnIrCqzxKU+QGje3+AuKvFasmy, issuerRevocationPublicKey: LS0tLS1CRUdJTiBQVUJMSUMgS0VZLS0tLS0KTUhZd0VBWUhLb1pJemowQ0FRWUZLNEVFQUNJRFlnQUVVeWpzYmtvL2kxSUg0ZEEvOURBeE15RW9YUFczVTRJRQpaMUh2K0VmWXhka1IrWWRLdzVYb09BeGRvVnl0blUzZzJNTStTZ01XK1QyZnZNVHQxOHR3QkVITVRQZnE1VHBoCmZ1VExVaitvSVJFbEFXSkNsOW44cTVRcWFLWjZaekNlCi0tLS0tRU5EIFBVQkxJQyBLRVktLS0tLQo=
2019-10-31 08:32:13,764 main INFO  HFCAClient:1542 - CA Version: 1.4.3
2019-10-31 08:32:14,474 main INFO  HFCAClient:594 - CA Name: , Version: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUNRakNDQWVtZ0F3SUJBZ0lRQTUxUzVhVjhPRktUREVrQURhL0I0VEFLQmdncWhrak9QUVFEQWpCek1Rc3cKQ1FZRFZRUUdFd0pWVXpFVE1CRUdBMVVFQ0JNS1EyRnNhV1p2Y201cFlURVdNQlFHQTFVRUJ4TU5VMkZ1SUVaeQpZVzVqYVhOamJ6RVpNQmNHQTFVRUNoTVFiM0puTWk1bGVHRnRjR3hsTG1OdmJURWNNQm9HQTFVRUF4TVRZMkV1CmIzSm5NaTVsZUdGdGNHeGxMbU52YlRBZUZ3MHhPREF5TWpVeE1qUXpNamxhRncweU9EQXlNak14TWpRek1qbGEKTUhNeEN6QUpCZ05WQkFZVEFsVlRNUk13RVFZRFZRUUlFd3BEWVd4cFptOXlibWxoTVJZd0ZBWURWUVFIRXcxVApZVzRnUm5KaGJtTnBjMk52TVJrd0Z3WURWUVFLRXhCdmNtY3lMbVY0WVcxd2JHVXVZMjl0TVJ3d0dnWURWUVFECkV4TmpZUzV2Y21jeUxtVjRZVzF3YkdVdVkyOXRNRmt3RXdZSEtvWkl6ajBDQVFZSUtvWkl6ajBEQVFjRFFnQUUKWDcxcjVqUE5WWUwrQ3FPSDFXWlhZNmJ2ZXBReUxGUkVIdFVzT3VYRmZqbGVycEd3a1BWSk5pcERaVWlmVFJTOAppbWZqK3M2dHg1cFJKZHk4YldESVZhTmZNRjB3RGdZRFZSMFBBUUgvQkFRREFnR21NQThHQTFVZEpRUUlNQVlHCkJGVWRKUUF3RHdZRFZSMFRBUUgvQkFVd0F3RUIvekFwQmdOVkhRNEVJZ1FnZXl0MlU4UlJMV3pwVTE0NEZBWTEKOVRtOWloTUw1VXJKVDM0VEczV2c4ajR3Q2dZSUtvWkl6ajBFQXdJRFJ3QXdSQUlnY20vOEFGdms3OXBaekhCdQo3dEV6WXhwTTk5QWpIbkk3bFF1Z2F5b0QrMkFDSUQ2c2dmTk56RWdSbS81aVpBRGVMQVBpb1VpQkpVcUFJV1lxCkhLYWxkWnBiCi0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K, issuerPublicKey: CgJPVQoEUm9sZQoMRW5yb2xsbWVudElEChBSZXZvY2F0aW9uSGFuZGxlEkQKIKUN1bxKXUsUNOy+bfScpF2LI3sPbJ6LX0LLIlXSuLgAEiB/qs9QkyV/5tIw2YPvFbUCsXLQk1NXOQZ+RxPM6YVtoBpECiBPeZPNPzi1vI7bw5YBvJeTOdOBO0gt/ZlIsn3uV/uPIRIgSXkrGdp/DOfpPDT2nRQh+leoXzxmB7BbO6iTZF1I6LgiRAogyvToDr9W4PgKW1cEO/LoPk9Hl0R9CgUlBTBimT3qqVISICC3xNHi9Q0P/H9DebPXiqQzKhq8uK20ZFlgLLzg1dUVIkQKIKSwLtmjfeVVsYgtGxIO+TEOwqxgc0fSKW06t2ix90C3EiABoRYyojpG96USz5VSgqhwiGUwGF1yasXK4rUFPqdHtCJECiDpPEL4uY5ua8X15HClIuj5XqmlhM27PbDiPMlU67ySQBIg2UUaB2RdOKSfzDPGPmJFzp6W1ITZhU/yHrqj1JeV5/MiRAogj0GBMlvZd7laaacSt1QPl2OLPCEele8RuW/0ZjOM0rMSIBYSJHFQzcKCtfTZSnqy8jTsUxdUaNZPOEaJwTQWwIEUKogBCiDIB3FLD2NlcDCHKUj9YiuKTzfvmKiXBaQI7nK/FQzyghIgoSQL4DaPx45ZmTSM25ZMZ0lUhLud2xFGN461WmjS9/0aINp2Tn0FVlkgq1ziFEkTjqNf0TtdpmeBdKz9NSPuiOEgIiD91wH9nsr1Luq9EppzmfeigiUYnkHqF98EjHWJuUjCGTJECiBDum1pl02apBwaDJIsIkfQ/0EcDGCmnjf5/s92xsDezxIg8c0IcNQjkf8H+OaEQ++R6Bs3XizBKzgdk1YOCGG3SvU6RAogmcVXh2wtQs6ex4T6D1GPFQeb3vX5p7LxXcoc8LNsDlcSIEPtAmlOwOU0BmodnqUvJR2kgAjymC7ciQ8z9E9Z+Up/QiB/RZnDddQpHKAFKJoNBaYqz/Jos24GNAKb+hJfrlF8N0ogkdLAh3B2lSWCpzDJliL7wATU9OIvjnZ4VmzQPX8xha1SIIQ6XWpZn5NGEMPdfoKXn262cOdbyiKjTLa+4nXEc0wy, issuerRevocationPublicKey: LS0tLS1CRUdJTiBQVUJMSUMgS0VZLS0tLS0KTUhZd0VBWUhLb1pJemowQ0FRWUZLNEVFQUNJRFlnQUU2bGtLdlNhMWY1RnJLMHZXVENieEFMbnhlRXFYZ3dKawpBYzk4bHVwWG5GQmNhMjdHWEp5Z0lqMnNLM0Q5UHd6QTVYeHQzeTRVS215SFFTUGhJU2Y1Nnh2c08xRlV6cUQ4CjlPSHpCUGpQdXhsRnl5SG5Uems2bFJRQ2dBVU1HcmZMCi0tLS0tRU5EIFBVQkxJQyBLRVktLS0tLQo=
2019-10-31 08:32:14,885 main INFO  HFCAClient:594 - CA Name: , Version: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUNRakNDQWVtZ0F3SUJBZ0lRQTUxUzVhVjhPRktUREVrQURhL0I0VEFLQmdncWhrak9QUVFEQWpCek1Rc3cKQ1FZRFZRUUdFd0pWVXpFVE1CRUdBMVVFQ0JNS1EyRnNhV1p2Y201cFlURVdNQlFHQTFVRUJ4TU5VMkZ1SUVaeQpZVzVqYVhOamJ6RVpNQmNHQTFVRUNoTVFiM0puTWk1bGVHRnRjR3hsTG1OdmJURWNNQm9HQTFVRUF4TVRZMkV1CmIzSm5NaTVsZUdGdGNHeGxMbU52YlRBZUZ3MHhPREF5TWpVeE1qUXpNamxhRncweU9EQXlNak14TWpRek1qbGEKTUhNeEN6QUpCZ05WQkFZVEFsVlRNUk13RVFZRFZRUUlFd3BEWVd4cFptOXlibWxoTVJZd0ZBWURWUVFIRXcxVApZVzRnUm5KaGJtTnBjMk52TVJrd0Z3WURWUVFLRXhCdmNtY3lMbVY0WVcxd2JHVXVZMjl0TVJ3d0dnWURWUVFECkV4TmpZUzV2Y21jeUxtVjRZVzF3YkdVdVkyOXRNRmt3RXdZSEtvWkl6ajBDQVFZSUtvWkl6ajBEQVFjRFFnQUUKWDcxcjVqUE5WWUwrQ3FPSDFXWlhZNmJ2ZXBReUxGUkVIdFVzT3VYRmZqbGVycEd3a1BWSk5pcERaVWlmVFJTOAppbWZqK3M2dHg1cFJKZHk4YldESVZhTmZNRjB3RGdZRFZSMFBBUUgvQkFRREFnR21NQThHQTFVZEpRUUlNQVlHCkJGVWRKUUF3RHdZRFZSMFRBUUgvQkFVd0F3RUIvekFwQmdOVkhRNEVJZ1FnZXl0MlU4UlJMV3pwVTE0NEZBWTEKOVRtOWloTUw1VXJKVDM0VEczV2c4ajR3Q2dZSUtvWkl6ajBFQXdJRFJ3QXdSQUlnY20vOEFGdms3OXBaekhCdQo3dEV6WXhwTTk5QWpIbkk3bFF1Z2F5b0QrMkFDSUQ2c2dmTk56RWdSbS81aVpBRGVMQVBpb1VpQkpVcUFJV1lxCkhLYWxkWnBiCi0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K, issuerPublicKey: CgJPVQoEUm9sZQoMRW5yb2xsbWVudElEChBSZXZvY2F0aW9uSGFuZGxlEkQKIKUN1bxKXUsUNOy+bfScpF2LI3sPbJ6LX0LLIlXSuLgAEiB/qs9QkyV/5tIw2YPvFbUCsXLQk1NXOQZ+RxPM6YVtoBpECiBPeZPNPzi1vI7bw5YBvJeTOdOBO0gt/ZlIsn3uV/uPIRIgSXkrGdp/DOfpPDT2nRQh+leoXzxmB7BbO6iTZF1I6LgiRAogyvToDr9W4PgKW1cEO/LoPk9Hl0R9CgUlBTBimT3qqVISICC3xNHi9Q0P/H9DebPXiqQzKhq8uK20ZFlgLLzg1dUVIkQKIKSwLtmjfeVVsYgtGxIO+TEOwqxgc0fSKW06t2ix90C3EiABoRYyojpG96USz5VSgqhwiGUwGF1yasXK4rUFPqdHtCJECiDpPEL4uY5ua8X15HClIuj5XqmlhM27PbDiPMlU67ySQBIg2UUaB2RdOKSfzDPGPmJFzp6W1ITZhU/yHrqj1JeV5/MiRAogj0GBMlvZd7laaacSt1QPl2OLPCEele8RuW/0ZjOM0rMSIBYSJHFQzcKCtfTZSnqy8jTsUxdUaNZPOEaJwTQWwIEUKogBCiDIB3FLD2NlcDCHKUj9YiuKTzfvmKiXBaQI7nK/FQzyghIgoSQL4DaPx45ZmTSM25ZMZ0lUhLud2xFGN461WmjS9/0aINp2Tn0FVlkgq1ziFEkTjqNf0TtdpmeBdKz9NSPuiOEgIiD91wH9nsr1Luq9EppzmfeigiUYnkHqF98EjHWJuUjCGTJECiBDum1pl02apBwaDJIsIkfQ/0EcDGCmnjf5/s92xsDezxIg8c0IcNQjkf8H+OaEQ++R6Bs3XizBKzgdk1YOCGG3SvU6RAogmcVXh2wtQs6ex4T6D1GPFQeb3vX5p7LxXcoc8LNsDlcSIEPtAmlOwOU0BmodnqUvJR2kgAjymC7ciQ8z9E9Z+Up/QiB/RZnDddQpHKAFKJoNBaYqz/Jos24GNAKb+hJfrlF8N0ogkdLAh3B2lSWCpzDJliL7wATU9OIvjnZ4VmzQPX8xha1SIIQ6XWpZn5NGEMPdfoKXn262cOdbyiKjTLa+4nXEc0wy, issuerRevocationPublicKey: LS0tLS1CRUdJTiBQVUJMSUMgS0VZLS0tLS0KTUhZd0VBWUhLb1pJemowQ0FRWUZLNEVFQUNJRFlnQUU2bGtLdlNhMWY1RnJLMHZXVENieEFMbnhlRXFYZ3dKawpBYzk4bHVwWG5GQmNhMjdHWEp5Z0lqMnNLM0Q5UHd6QTVYeHQzeTRVS215SFFTUGhJU2Y1Nnh2c08xRlV6cUQ4CjlPSHpCUGpQdXhsRnl5SG5Uems2bFJRQ2dBVU1HcmZMCi0tLS0tRU5EIFBVQkxJQyBLRVktLS0tLQo=
2019-10-31 08:32:14,886 main INFO  HFCAClient:1542 - CA Version: 1.4.3
Constructing channel foo
Created channel foo
2019-10-31 08:32:21,328 main INFO  Channel:851 - Channel{id: 3, name: foo} joining Peer{ id: 5, name: peer0.org1.example.com, channelName: null, url: grpc://139.9.120.244:7051}.
2019-10-31 08:32:21,756 main INFO  Channel:883 - Peer Peer{ id: 5, name: peer0.org1.example.com, channelName: foo, url: grpc://139.9.120.244:7051} joined into channel Channel{id: 3, name: foo}
Peer peer0.org1.example.com joined channel foo
2019-10-31 08:32:21,757 main INFO  Channel:851 - Channel{id: 3, name: foo} joining Peer{ id: 8, name: peer1.org1.example.com, channelName: null, url: grpc://139.9.120.244:7056}.
2019-10-31 08:32:22,339 main INFO  Channel:883 - Peer Peer{ id: 8, name: peer1.org1.example.com, channelName: foo, url: grpc://139.9.120.244:7056} joined into channel Channel{id: 3, name: foo}
Peer peer1.org1.example.com joined channel foo
2019-10-31 08:32:23,287 main INFO  Channel:1259 - Channel Channel{id: 3, name: foo} eventThread started shutdown: false  thread: null 
Finished initialization channel foo
2019-10-31 08:32:23,472 pool-1-thread-1 INFO  Channel:5988 - Channel foo eventThread shutting down. shutdown: true  thread: pool-1-thread-1 
2019-10-31 08:32:24,514 main INFO  Channel:1259 - Channel Channel{id: 16, name: foo} eventThread started shutdown: false  thread: null 
Running channel foo
Creating install proposal
Sending install proposal
2019-10-31 08:32:26,643 main INFO  InstallProposalBuilder:243 - Installing 'example_cc_go::github.com/example_cc::1' language Go chaincode from directory: 'D:\code\java\fabric-sdk-java\src\test\fixture\sdkintegration\gocc\sample1\src\github.com\example_cc' with source location: 'src\github.com\example_cc'. chaincodePath:'github.com/example_cc'
Successful install proposal response Txid: 9739297ec641c3aba91459af03b86cadf384b7beced04d31133748544f31bec9 from peer peer0.org1.example.com
Successful install proposal response Txid: 9739297ec641c3aba91459af03b86cadf384b7beced04d31133748544f31bec9 from peer peer1.org1.example.com
Received 2 install proposal responses. Successful+verified: 2 . Failed: 0
Sending instantiateProposalRequest to all peers with arguments: a and b set to 100 and 200 respectively
Succesful instantiate proposal response Txid: c61076b29a93edfcad99c5972cbeaba09f1a64cdedf012e273f0b30e3086213f from peer peer0.org1.example.com
Succesful instantiate proposal response Txid: c61076b29a93edfcad99c5972cbeaba09f1a64cdedf012e273f0b30e3086213f from peer peer1.org1.example.com
Received 2 instantiate proposal responses. Successful+verified: 2 . Failed: 0
Sending instantiateTransaction to orderer with a and b set to 100 and 200 respectively
Finished instantiate transaction with transaction id c61076b29a93edfcad99c5972cbeaba09f1a64cdedf012e273f0b30e3086213f
sending transactionProposal to all peers with arguments: move(a,b,100)
Successful transaction proposal response Txid: cc6cd1cdd76d3188a1772a95115463d2f2cf835b091e403fb0f5d1d1a8e396c5 from peer peer0.org1.example.com
Successful transaction proposal response Txid: cc6cd1cdd76d3188a1772a95115463d2f2cf835b091e403fb0f5d1d1a8e396c5 from peer peer1.org1.example.com
Received 2 transaction proposal responses. Successful+verified: 2 . Failed: 0
Successfully received transaction proposal responses.
Sending chaincode transaction(move a,b,100) to orderer.
Finished transaction with transaction id cc6cd1cdd76d3188a1772a95115463d2f2cf835b091e403fb0f5d1d1a8e396c5
Now query chaincode for the value of b.
RECEIVED Chaincode event with handle: CHAINCODE_EVENTS_HANDLE369bdd4e-435a-4e46-9488-71717c3494e6CHAINCODE_EVENTS_HANDLE, chaincode Id: example_cc_go, chaincode event name: event, transaction id: cc6cd1cdd76d3188a1772a95115463d2f2cf835b091e403fb0f5d1d1a8e396c5, event payload: "!", from event source: peer1.org1.example.com
RECEIVED Chaincode event with handle: CHAINCODE_EVENTS_HANDLE369bdd4e-435a-4e46-9488-71717c3494e6CHAINCODE_EVENTS_HANDLE, chaincode Id: example_cc_go, chaincode event name: event, transaction id: cc6cd1cdd76d3188a1772a95115463d2f2cf835b091e403fb0f5d1d1a8e396c5, event payload: "!", from event source: peer0.org1.example.com
Query payload of b from peer peer0.org1.example.com returned 300
Query payload of b from peer peer1.org1.example.com returned 300
Channel info for : foo
Channel height: 3
Chain current block hash: d3f280410355c8e67d380177971aafa1758429ab12e35288cdee9bce7118dc22
Chainl previous block hash: c56375d9e734951604eeb129c21a0a72dfb2c8b9909bdf177b0f2050be756d77
queryBlockByNumber returned correct block with blockNumber 2 
 previous_hash c56375d9e734951604eeb129c21a0a72dfb2c8b9909bdf177b0f2050be756d77
queryBlockByHash returned block with blockNumber 1
queryBlockByTxID returned block with blockNumber 2
QueryTransactionByID returned TransactionInfo: txID cc6cd1cdd76d3188a1772a95115463d2f2cf835b091e403fb0f5d1d1a8e396c5
     validation code 0
Running for Channel foo done


Constructing channel bar
2019-10-31 08:32:36,411 pool-1-thread-1 INFO  Channel:5988 - Channel foo eventThread shutting down. shutdown: true  thread: pool-1-thread-1 
Created channel bar
2019-10-31 08:32:36,908 main INFO  Channel:851 - Channel{id: 32, name: bar} joining Peer{ id: 34, name: peer0.org2.example.com, channelName: null, url: grpc://139.9.127.140:8051}.
2019-10-31 08:32:37,276 main INFO  Channel:883 - Peer Peer{ id: 34, name: peer0.org2.example.com, channelName: bar, url: grpc://139.9.127.140:8051} joined into channel Channel{id: 32, name: bar}
Peer peer0.org2.example.com joined channel bar
2019-10-31 08:32:37,277 main INFO  Channel:851 - Channel{id: 32, name: bar} joining Peer{ id: 37, name: peer1.org2.example.com, channelName: null, url: grpc://139.9.127.140:8056}.
2019-10-31 08:32:37,585 main INFO  Channel:883 - Peer Peer{ id: 37, name: peer1.org2.example.com, channelName: bar, url: grpc://139.9.127.140:8056} joined into channel Channel{id: 32, name: bar}
Peer peer1.org2.example.com joined channel bar
2019-10-31 08:32:38,335 main INFO  Channel:1259 - Channel Channel{id: 32, name: bar} eventThread started shutdown: false  thread: null 
Finished initialization channel bar
2019-10-31 08:32:38,515 pool-1-thread-1 INFO  Channel:5988 - Channel bar eventThread shutting down. shutdown: true  thread: pool-1-thread-1 
2019-10-31 08:32:39,325 main INFO  Channel:1259 - Channel Channel{id: 45, name: bar} eventThread started shutdown: false  thread: null 
Running channel bar
Creating install proposal
Sending install proposal
2019-10-31 08:32:42,368 main INFO  InstallProposalBuilder:257 - Installing 'example_cc_go::github.com/example_cc::1'  Go chaincode chaincodePath:'github.com/example_cc' from input stream
Successful install proposal response Txid: 24879121a6a7945dc12708d57f6fbb294e03fc3ce28d5a0dcaabeaf7012aee45 from peer peer1.org2.example.com
Successful install proposal response Txid: 24879121a6a7945dc12708d57f6fbb294e03fc3ce28d5a0dcaabeaf7012aee45 from peer peer0.org2.example.com
Received 2 install proposal responses. Successful+verified: 2 . Failed: 0
Sending instantiateProposalRequest to all peers with arguments: a and b set to 100 and 300 respectively
Succesful instantiate proposal response Txid: e0d1f86d0bda575e12bed47f0a0ed45047ead6b495a6755f6cfdf3e242484b0c from peer peer1.org2.example.com
Succesful instantiate proposal response Txid: e0d1f86d0bda575e12bed47f0a0ed45047ead6b495a6755f6cfdf3e242484b0c from peer peer0.org2.example.com
Received 2 instantiate proposal responses. Successful+verified: 2 . Failed: 0
Sending instantiateTransaction to orderer with a and b set to 100 and 300 respectively
Finished instantiate transaction with transaction id e0d1f86d0bda575e12bed47f0a0ed45047ead6b495a6755f6cfdf3e242484b0c
sending transactionProposal to all peers with arguments: move(a,b,100)
Successful transaction proposal response Txid: b2ee5139866bdba5628b38fae8bfd2289bcff3810a57b38db3a5d283ae19f13a from peer peer1.org2.example.com
Successful transaction proposal response Txid: b2ee5139866bdba5628b38fae8bfd2289bcff3810a57b38db3a5d283ae19f13a from peer peer0.org2.example.com
Received 2 transaction proposal responses. Successful+verified: 2 . Failed: 0
Successfully received transaction proposal responses.
Sending chaincode transaction(move a,b,100) to orderer.
Finished transaction with transaction id b2ee5139866bdba5628b38fae8bfd2289bcff3810a57b38db3a5d283ae19f13a
Now query chaincode for the value of b.
Query payload of b from peer peer1.org2.example.com returned 400
Query payload of b from peer peer0.org2.example.com returned 400
Channel info for : bar
Channel height: 3
Chain current block hash: cf62df8852aa3d5cba4802a367829f497e9ea93e897347c7c684588296597ff0
Chainl previous block hash: b656f0abd315a31ec433d84c690563e5f1d43ace6c9a4704f431bc93d2217d13
queryBlockByNumber returned correct block with blockNumber 2 
 previous_hash b656f0abd315a31ec433d84c690563e5f1d43ace6c9a4704f431bc93d2217d13
queryBlockByHash returned block with blockNumber 1
queryBlockByTxID returned block with blockNumber 2
QueryTransactionByID returned TransactionInfo: txID b2ee5139866bdba5628b38fae8bfd2289bcff3810a57b38db3a5d283ae19f13a
     validation code 0
Running for Channel bar done

Traverse the blocks for chain bar 
current block number 2 has data hash: d7f8a77322f8c2eeba22c677dc93e4e5463e08a561544e3d419a80bdededf96e
current block number 2 has previous hash id: b656f0abd315a31ec433d84c690563e5f1d43ace6c9a4704f431bc93d2217d13
current block number 2 has calculated block hash is cf62df8852aa3d5cba4802a367829f497e9ea93e897347c7c684588296597ff0
current block number 2 has 1 envelope count:
  Transaction number 1 has transaction id: b2ee5139866bdba5628b38fae8bfd2289bcff3810a57b38db3a5d283ae19f13a
  Transaction number 1 has channel id: bar
  Transaction number 1 has epoch: 0
  Transaction number 1 has transaction timestamp: 十月 31,  2019  16:32:48 下午
  Transaction number 1 has type id: TRANSACTION_ENVELOPE
  Transaction number 1 has nonce : cc01e61ad5e9eee37d92b0e61455bee607d68ea2cd99851a
  Transaction number 1 has submitter mspid: Org2MSP,  certificate: -----BEGIN CERTIFICATE-----
MIICjjCCAjWgAwIBAgIUGbdnI9z7ZEn9k2F+M51nNs/WNf0wCgYIKoZIzj0EAwIw
czELMAkGA1UEBhMCVVMxEzARBgNVBAgTCkNhbGlmb3JuaWExFjAUBgNVBAcTDVNh
biBGcmFuY2lzY28xGTAXBgNVBAoTEG9yZzIuZXhhbXBsZS5jb20xHDAaBgNVBAMT
E2NhLm9yZzIuZXhhbXBsZS5jb20wHhcNMTkxMDMxMDgyNzAwWhcNMjAxMDMwMDgz
MjAwWjBCMTAwDQYDVQQLEwZjbGllbnQwCwYDVQQLEwRvcmcxMBIGA1UECxMLZGVw
YXJ0bWVudDExDjAMBgNVBAMTBXVzZXIxMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcD
QgAErrfwntR1lCvVcq3PmD1sPiT4cnPZQzAJCafmbCyDnCDBrU/03PAcHf+RnFzW
npwvJlsh+Lcn2RrD5qWLs4/OKqOB1zCB1DAOBgNVHQ8BAf8EBAMCB4AwDAYDVR0T
AQH/BAIwADAdBgNVHQ4EFgQUT88lh1juaPRr3yv6/Ck28Q/MaRswKwYDVR0jBCQw
IoAgeyt2U8RRLWzpU144FAY19Tm9ihML5UrJT34TG3Wg8j4waAYIKgMEBQYHCAEE
XHsiYXR0cnMiOnsiaGYuQWZmaWxpYXRpb24iOiJvcmcxLmRlcGFydG1lbnQxIiwi
aGYuRW5yb2xsbWVudElEIjoidXNlcjEiLCJoZi5UeXBlIjoiY2xpZW50In19MAoG
CCqGSM49BAMCA0cAMEQCIFN6DQmNGbXsD0lFtIEGUVZP/I+dCQvoEbmv0eu3MYMN
AiAkirZhuj2u7QRsC5r+pz1ZEdwKQ56heSxBJ5uAX3R/gw==
-----END CERTIFICATE-----

  Transaction number 1 has 1 actions
  Transaction number 1 isValid true
  Transaction number 1 validation code 0
   Transaction action 1 has response status 210
   Transaction action 1 has response message bytes as string: 
   Transaction action 1 has 2 endorsements
Endorser 0 signature: 30440220469e8ac76953f58ac89b7fe4cce79f21acbe2a647c572a94f056d7724836800b022072d52d5bfb07c6bb43da1aa2114c5425aa4fd3979f2c4726b6ed56d9c1695cce
Endorser 0 endorser: mspid Org2MSP 
 certificate -----BEGIN CERTIFICATE-----
MIICGDCCAb+gAwIBAgIQKHCjvLJSTkKm5lsAG4StsTAKBggqhkjOPQQDAjBzMQsw
CQYDVQQGEwJVUzETMBEGA1UECBMKQ2FsaWZvcm5pYTEWMBQGA1UEBxMNU2FuIEZy
YW5jaXNjbzEZMBcGA1UEChMQb3JnMi5leGFtcGxlLmNvbTEcMBoGA1UEAxMTY2Eu
b3JnMi5leGFtcGxlLmNvbTAeFw0xODAyMjUxMjQzMjlaFw0yODAyMjMxMjQzMjla
MFsxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpDYWxpZm9ybmlhMRYwFAYDVQQHEw1T
YW4gRnJhbmNpc2NvMR8wHQYDVQQDExZwZWVyMS5vcmcyLmV4YW1wbGUuY29tMFkw
EwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEIPHSGaXYokkyDT7hjv7xR7qdr/4unay4
6ney+f+SaX3/+GS23ETzxjeZYyoKYy+nMjTGVtMx1k9m/KHHZUS4PaNNMEswDgYD
VR0PAQH/BAQDAgeAMAwGA1UdEwEB/wQCMAAwKwYDVR0jBCQwIoAgeyt2U8RRLWzp
U144FAY19Tm9ihML5UrJT34TG3Wg8j4wCgYIKoZIzj0EAwIDRwAwRAIgRiUmbSDL
ZT4ETQzsS57MpfinlBo+WM/3ChUtTOL8BlgCIB8jfwjtaP22vH4w+V52ztTgQCnq
lCO/1jpx9z0ii78C
-----END CERTIFICATE-----

Endorser 1 signature: 3045022100f46315271e3646edaf774824338ab01acec8fd5fa774b8b8238b46d37bc5d854022000e9c3bd0f3de5a041556c0b2470248b8d1a993632f018f4c9e5ee27fda65363
Endorser 1 endorser: mspid Org2MSP 
 certificate -----BEGIN CERTIFICATE-----
MIICGTCCAcCgAwIBAgIRAKoFq36AGyh9tmw1qzjKp2YwCgYIKoZIzj0EAwIwczEL
MAkGA1UEBhMCVVMxEzARBgNVBAgTCkNhbGlmb3JuaWExFjAUBgNVBAcTDVNhbiBG
cmFuY2lzY28xGTAXBgNVBAoTEG9yZzIuZXhhbXBsZS5jb20xHDAaBgNVBAMTE2Nh
Lm9yZzIuZXhhbXBsZS5jb20wHhcNMTgwMjI1MTI0MzI5WhcNMjgwMjIzMTI0MzI5
WjBbMQswCQYDVQQGEwJVUzETMBEGA1UECBMKQ2FsaWZvcm5pYTEWMBQGA1UEBxMN
U2FuIEZyYW5jaXNjbzEfMB0GA1UEAxMWcGVlcjAub3JnMi5leGFtcGxlLmNvbTBZ
MBMGByqGSM49AgEGCCqGSM49AwEHA0IABFBM3gDUs/4Mp9DyF/uiUQkQk1UvqmmC
uhuAXJgeTAob/tzvsLGGRS78dsuPVSGVS3p4vtuPhUBMVKtrnscgjemjTTBLMA4G
A1UdDwEB/wQEAwIHgDAMBgNVHRMBAf8EAjAAMCsGA1UdIwQkMCKAIHsrdlPEUS1s
6VNeOBQGNfU5vYoTC+VKyU9+Ext1oPI+MAoGCCqGSM49BAMCA0cAMEQCIDbFc/hr
0RYfp0e9HqBW+tel9c9VCW7E+C7XO4e7ZYBJAiAVkjEFKpKadLUpA2cK0YHobNRH
zxIaKjL+wLVfr2wTzQ==
-----END CERTIFICATE-----

   Transaction action 1 has 4 chaincode input arguments
     Transaction action 1 has chaincode input argument 0 is: move
     Transaction action 1 has chaincode input argument 1 is: a
     Transaction action 1 has chaincode input argument 2 is: b
     Transaction action 1 has chaincode input argument 3 is: 100
   Transaction action 1 proposal response status: 210
   Transaction action 1 proposal response payload: :)
   Transaction action 1 proposal chaincodeIDName: example_cc_go, chaincodeIDVersion: 1
   Transaction action 1 has 2 name space read write sets
     Namespace example_cc_go read set 0 key a  version [1:0]
     Namespace example_cc_go read set 1 key b  version [1:0]
     Namespace example_cc_go write set 0 key a has value '400' 
     Namespace example_cc_go write set 1 key b has value '400' 
     Namespace lscc read set 0 key example_cc_go  version [1:0]
current block number 1 has data hash: c5674608142b1894fc6f5a28443caa4e31a75a9e51ea11742f7bfb801a3155d3
current block number 1 has previous hash id: b7d5e295c822c978df1107d07923348abdda0c9e0dfbe2ca109e5ffcd820333c
current block number 1 has calculated block hash is b656f0abd315a31ec433d84c690563e5f1d43ace6c9a4704f431bc93d2217d13
current block number 1 has 1 envelope count:
  Transaction number 1 has transaction id: e0d1f86d0bda575e12bed47f0a0ed45047ead6b495a6755f6cfdf3e242484b0c
  Transaction number 1 has channel id: bar
  Transaction number 1 has epoch: 0
  Transaction number 1 has transaction timestamp: 十月 31,  2019  16:32:45 下午
  Transaction number 1 has type id: TRANSACTION_ENVELOPE
  Transaction number 1 has nonce : 225778237579331763d6b3eb57b4604d08a20ed4d0bb371b
  Transaction number 1 has submitter mspid: Org2MSP,  certificate: -----BEGIN CERTIFICATE-----
MIICGjCCAcCgAwIBAgIRAIrZokP5xguxCqWjUeu0jnAwCgYIKoZIzj0EAwIwczEL
MAkGA1UEBhMCVVMxEzARBgNVBAgTCkNhbGlmb3JuaWExFjAUBgNVBAcTDVNhbiBG
cmFuY2lzY28xGTAXBgNVBAoTEG9yZzIuZXhhbXBsZS5jb20xHDAaBgNVBAMTE2Nh
Lm9yZzIuZXhhbXBsZS5jb20wHhcNMTgwMjI1MTI0MzI5WhcNMjgwMjIzMTI0MzI5
WjBbMQswCQYDVQQGEwJVUzETMBEGA1UECBMKQ2FsaWZvcm5pYTEWMBQGA1UEBxMN
U2FuIEZyYW5jaXNjbzEfMB0GA1UEAwwWQWRtaW5Ab3JnMi5leGFtcGxlLmNvbTBZ
MBMGByqGSM49AgEGCCqGSM49AwEHA0IABGDqXVD4yOX65oU0eY3j5UtD8Gr8n/s+
eODjPP76wNeBoSqljQYM+D953dBtzZ87udrwQ2uvcpUI1R1mHTMuNmSjTTBLMA4G
A1UdDwEB/wQEAwIHgDAMBgNVHRMBAf8EAjAAMCsGA1UdIwQkMCKAIHsrdlPEUS1s
6VNeOBQGNfU5vYoTC+VKyU9+Ext1oPI+MAoGCCqGSM49BAMCA0gAMEUCIQCojuxd
EqSDDDUUJstAmAqU65xkd1/Yf0BVpLdCe++WigIgLWC9rBPpUa+Yhe3yy00+BlqG
xZ0h2eeiHaMuF6Qawy4=
-----END CERTIFICATE-----

  Transaction number 1 has 1 actions
  Transaction number 1 isValid true
  Transaction number 1 validation code 0
   Transaction action 1 has response status 200
   Transaction action 1 has response message bytes as string: 
   Transaction action 1 has 2 endorsements
Endorser 0 signature: 3045022100f96bb675772470015337c95585f1c3226f57e367bc1c87f7e50c3fec3af5261102200308c6b2da517ff197356ae7d78fddc307d90818bd7cfaa8b9ed97212a8afb8a
Endorser 0 endorser: mspid Org2MSP 
 certificate -----BEGIN CERTIFICATE-----
MIICGDCCAb+gAwIBAgIQKHCjvLJSTkKm5lsAG4StsTAKBggqhkjOPQQDAjBzMQsw
CQYDVQQGEwJVUzETMBEGA1UECBMKQ2FsaWZvcm5pYTEWMBQGA1UEBxMNU2FuIEZy
YW5jaXNjbzEZMBcGA1UEChMQb3JnMi5leGFtcGxlLmNvbTEcMBoGA1UEAxMTY2Eu
b3JnMi5leGFtcGxlLmNvbTAeFw0xODAyMjUxMjQzMjlaFw0yODAyMjMxMjQzMjla
MFsxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpDYWxpZm9ybmlhMRYwFAYDVQQHEw1T
YW4gRnJhbmNpc2NvMR8wHQYDVQQDExZwZWVyMS5vcmcyLmV4YW1wbGUuY29tMFkw
EwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEIPHSGaXYokkyDT7hjv7xR7qdr/4unay4
6ney+f+SaX3/+GS23ETzxjeZYyoKYy+nMjTGVtMx1k9m/KHHZUS4PaNNMEswDgYD
VR0PAQH/BAQDAgeAMAwGA1UdEwEB/wQCMAAwKwYDVR0jBCQwIoAgeyt2U8RRLWzp
U144FAY19Tm9ihML5UrJT34TG3Wg8j4wCgYIKoZIzj0EAwIDRwAwRAIgRiUmbSDL
ZT4ETQzsS57MpfinlBo+WM/3ChUtTOL8BlgCIB8jfwjtaP22vH4w+V52ztTgQCnq
lCO/1jpx9z0ii78C
-----END CERTIFICATE-----

Endorser 1 signature: 304402203fb7e9e2eb1645e3c08231980b90d6bf766362d0ece53cbe3eec878d98d51bf3022078b19c7909fb7135313cd74878ad9173761b4d033e1598033aae97ae9ebd79b5
Endorser 1 endorser: mspid Org2MSP 
 certificate -----BEGIN CERTIFICATE-----
MIICGTCCAcCgAwIBAgIRAKoFq36AGyh9tmw1qzjKp2YwCgYIKoZIzj0EAwIwczEL
MAkGA1UEBhMCVVMxEzARBgNVBAgTCkNhbGlmb3JuaWExFjAUBgNVBAcTDVNhbiBG
cmFuY2lzY28xGTAXBgNVBAoTEG9yZzIuZXhhbXBsZS5jb20xHDAaBgNVBAMTE2Nh
Lm9yZzIuZXhhbXBsZS5jb20wHhcNMTgwMjI1MTI0MzI5WhcNMjgwMjIzMTI0MzI5
WjBbMQswCQYDVQQGEwJVUzETMBEGA1UECBMKQ2FsaWZvcm5pYTEWMBQGA1UEBxMN
U2FuIEZyYW5jaXNjbzEfMB0GA1UEAxMWcGVlcjAub3JnMi5leGFtcGxlLmNvbTBZ
MBMGByqGSM49AgEGCCqGSM49AwEHA0IABFBM3gDUs/4Mp9DyF/uiUQkQk1UvqmmC
uhuAXJgeTAob/tzvsLGGRS78dsuPVSGVS3p4vtuPhUBMVKtrnscgjemjTTBLMA4G
A1UdDwEB/wQEAwIHgDAMBgNVHRMBAf8EAjAAMCsGA1UdIwQkMCKAIHsrdlPEUS1s
6VNeOBQGNfU5vYoTC+VKyU9+Ext1oPI+MAoGCCqGSM49BAMCA0cAMEQCIDbFc/hr
0RYfp0e9HqBW+tel9c9VCW7E+C7XO4e7ZYBJAiAVkjEFKpKadLUpA2cK0YHobNRH
zxIaKjL+wLVfr2wTzQ==
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
current block number 0 has data hash: 1f97161f511cf90e5ef99372e80d9ab93c008bd5a105367e2513bd9c1606be64
current block number 0 has previous hash id: 
current block number 0 has calculated block hash is b7d5e295c822c978df1107d07923348abdda0c9e0dfbe2ca109e5ffcd820333c
current block number 0 has 1 envelope count:
  Transaction number 1 has transaction id: 
  Transaction number 1 has channel id: bar
  Transaction number 1 has epoch: 0
  Transaction number 1 has transaction timestamp: 十月 31,  2019  16:32:35 下午
  Transaction number 1 has type id: ENVELOPE
  Transaction number 1 has nonce : fb65564058081063a25bd4bc93202424764592b6190cf0b2
  Transaction number 1 has submitter mspid: OrdererMSP,  certificate: -----BEGIN CERTIFICATE-----
MIICCzCCAbKgAwIBAgIQUcfZvWT8UgJJ30cDzW15bDAKBggqhkjOPQQDAjBpMQsw
CQYDVQQGEwJVUzETMBEGA1UECBMKQ2FsaWZvcm5pYTEWMBQGA1UEBxMNU2FuIEZy
YW5jaXNjbzEUMBIGA1UEChMLZXhhbXBsZS5jb20xFzAVBgNVBAMTDmNhLmV4YW1w
bGUuY29tMB4XDTE4MDIyNTEyNDMyOVoXDTI4MDIyMzEyNDMyOVowWDELMAkGA1UE
BhMCVVMxEzARBgNVBAgTCkNhbGlmb3JuaWExFjAUBgNVBAcTDVNhbiBGcmFuY2lz
Y28xHDAaBgNVBAMTE29yZGVyZXIuZXhhbXBsZS5jb20wWTATBgcqhkjOPQIBBggq
hkjOPQMBBwNCAARQfP/qUmnEcXIlE5PlkR4RCMn2XykMsPFZN0k1XfpkSA4KP0nC
ALUgiITKLsOQohYA7oDaFQD/ZhaRswgwEgmNo00wSzAOBgNVHQ8BAf8EBAMCB4Aw
DAYDVR0TAQH/BAIwADArBgNVHSMEJDAigCAZtRU3kIVNroUKD5QVcPw8VpuHhyOT
OtWpwxnSk/LUkjAKBggqhkjOPQQDAgNHADBEAiApAQ0e/qdVsd5qtXGHqYKRt30Y
LPaGPmy8wbX8+/KDhwIgXtt1TL97Z0rfq7iKXzXLRNk8jNntsrmRFoLVstXr3dA=
-----END CERTIFICATE-----

That's all folks!
Tests run: 1, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 42.957 sec - in org.hyperledger.fabric.sdkintegration.End2endIT

Results :

Tests run: 1, Failures: 0, Errors: 0, Skipped: 0

[INFO] 
[INFO] --- jacoco-maven-plugin:0.8.2:report (post-unit-test) @ fabric-sdk-java ---
[INFO] Loading execution data file D:\code\java\fabric-sdk-java\target\coverage-reports\jacoco-ut.exec
[INFO] Analyzed bundle 'fabric-java-sdk' with 252 classes
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  01:43 min
[INFO] Finished at: 2019-10-31T16:32:54+08:00
[INFO] ------------------------------------------------------------------------
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

2019-10-31 08:34:27,499 main INFO  HFCAClient:594 - CA Name: ca0, Version: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUNRekNDQWVxZ0F3SUJBZ0lSQU0vdmFEdlBzeUlpQzlodm41bm5SOEF3Q2dZSUtvWkl6ajBFQXdJd2N6RUwKTUFrR0ExVUVCaE1DVlZNeEV6QVJCZ05WQkFnVENrTmhiR2xtYjNKdWFXRXhGakFVQmdOVkJBY1REVk5oYmlCRwpjbUZ1WTJselkyOHhHVEFYQmdOVkJBb1RFRzl5WnpFdVpYaGhiWEJzWlM1amIyMHhIREFhQmdOVkJBTVRFMk5oCkxtOXlaekV1WlhoaGJYQnNaUzVqYjIwd0hoY05NVGd3TWpJMU1USTBNekk1V2hjTk1qZ3dNakl6TVRJME16STUKV2pCek1Rc3dDUVlEVlFRR0V3SlZVekVUTUJFR0ExVUVDQk1LUTJGc2FXWnZjbTVwWVRFV01CUUdBMVVFQnhNTgpVMkZ1SUVaeVlXNWphWE5qYnpFWk1CY0dBMVVFQ2hNUWIzSm5NUzVsZUdGdGNHeGxMbU52YlRFY01Cb0dBMVVFCkF4TVRZMkV1YjNKbk1TNWxlR0Z0Y0d4bExtTnZiVEJaTUJNR0J5cUdTTTQ5QWdFR0NDcUdTTTQ5QXdFSEEwSUEKQkxxSTlkWDdkOU5HbzNndUw1RlA4b3RHc2lCak43QnpkNmRHL0NheUpEZmpOUkczNFlPOHQyOTl1NkVvRlh2egpwY2pBTUd1MFVLVHJ6TWZjeU91emNNeWpYekJkTUE0R0ExVWREd0VCL3dRRUF3SUJwakFQQmdOVkhTVUVDREFHCkJnUlZIU1VBTUE4R0ExVWRFd0VCL3dRRk1BTUJBZjh3S1FZRFZSME9CQ0lFSUxITU5NUHkwTStBZUdqNk9ob1IKaDAwZ1FUQ0VYOWp1czIwdVdVVFhkbmNjTUFvR0NDcUdTTTQ5QkFNQ0EwY0FNRVFDSUY3V2wzQTExekVOcjFDbwpxR3l1M2g0ZkN1a2t0RlZ5Ry9XUEpVeWxWWGpJQWlCOUxqcFhtOUVSZ0pNZlpzakRJekNqOU00YVF1Vk45WExrClhueDB1b0t6N2c9PQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==, issuerPublicKey: CgJPVQoEUm9sZQoMRW5yb2xsbWVudElEChBSZXZvY2F0aW9uSGFuZGxlEkQKIDwI9XgGar29lWsgJQ5P++7nzIIlwWWGLEJ51ykde2A1EiCqCseWTnj4fux5l9ozepRqBhlZDfRZQFOKy755TIRikhpECiBvNt5Wcruon1yTI2OEtyActT1S0GLFcfCWXRMFykliiBIgL2P8/HJvbEI5pLb0LgoTUA1JDYYS+/MKC5irpY6t25wiRAogCAVRXVLX9SAwPD64Io0XEBFzpU0AOLnlUO84CJEN/XMSINGlHg7UFotyrB8gssFv3O56azHl+2X+k0nC2fS4IJY7IkQKILXIuSKsaLPOEnzyALvLpiW5rwRrAZZGHtkGx4CDUyY3EiDTMRCTEROrAXB/ZINA+RP3FzeUgnDLxLOes+OubkOQIyJECiA0wS8aoljJ6XkaAm6viC3+OY1WhN+zlEgfckCrIeFzixIgOKoxJtgZrFma+LPjLye6/RYlejeNegmSePueBMhOctYiRAogP3UpF6MJUiwgP1WAEdcEUmA1qBzM/pnh/P4DvTClVNsSII0ME/JUvx2G/KanqXhHSdiOPO8JMvl/oT9j86NE5acMKogBCiAkGHyPPIpfZ62j37rU+vuyhyVn3GTzHxzfENb4L81d9hIg4lovQafbr+EQ8oOgJNQYJTNoxrwt03gX0KoS351tA9AaIAprAFVW8Rj/oz5qv8EgezttuHVW6CeYxhClVaUXgkv8IiCB5IQt3kHBcfaLZ0G6T07NcgX0yEcLq/SCjjIzC+OMITJECiBjX+SptFK5yiKrp6p2unJEQzicZrOl7pcjQaYCRscHxBIgNa9BFzQiJmywsmJlMcjSexW66XrrJZzTGZIGjeuiobU6RAogiyMMfc2QIHR94xmd+qIfFFeu8C0G3x/as3asLSH63YcSIEPbCHzdb/sMxS5h42sPx+bhLbJ0UzYMapdOKilxyluFQiC+JXB0Nrg+JUDkXOO30VuNa1OWTaY+uui66lvI59+s/EogS5zQNR8QLbjptQUWittI672tran5xUvtidx7QeTSjQVSIHRZz7ANrFN/racCNVLnIrCqzxKU+QGje3+AuKvFasmy, issuerRevocationPublicKey: LS0tLS1CRUdJTiBQVUJMSUMgS0VZLS0tLS0KTUhZd0VBWUhLb1pJemowQ0FRWUZLNEVFQUNJRFlnQUVVeWpzYmtvL2kxSUg0ZEEvOURBeE15RW9YUFczVTRJRQpaMUh2K0VmWXhka1IrWWRLdzVYb09BeGRvVnl0blUzZzJNTStTZ01XK1QyZnZNVHQxOHR3QkVITVRQZnE1VHBoCmZ1VExVaitvSVJFbEFXSkNsOW44cTVRcWFLWjZaekNlCi0tLS0tRU5EIFBVQkxJQyBLRVktLS0tLQo=
2019-10-31 08:34:28,415 main INFO  HFCAClient:594 - CA Name: ca0, Version: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUNRekNDQWVxZ0F3SUJBZ0lSQU0vdmFEdlBzeUlpQzlodm41bm5SOEF3Q2dZSUtvWkl6ajBFQXdJd2N6RUwKTUFrR0ExVUVCaE1DVlZNeEV6QVJCZ05WQkFnVENrTmhiR2xtYjNKdWFXRXhGakFVQmdOVkJBY1REVk5oYmlCRwpjbUZ1WTJselkyOHhHVEFYQmdOVkJBb1RFRzl5WnpFdVpYaGhiWEJzWlM1amIyMHhIREFhQmdOVkJBTVRFMk5oCkxtOXlaekV1WlhoaGJYQnNaUzVqYjIwd0hoY05NVGd3TWpJMU1USTBNekk1V2hjTk1qZ3dNakl6TVRJME16STUKV2pCek1Rc3dDUVlEVlFRR0V3SlZVekVUTUJFR0ExVUVDQk1LUTJGc2FXWnZjbTVwWVRFV01CUUdBMVVFQnhNTgpVMkZ1SUVaeVlXNWphWE5qYnpFWk1CY0dBMVVFQ2hNUWIzSm5NUzVsZUdGdGNHeGxMbU52YlRFY01Cb0dBMVVFCkF4TVRZMkV1YjNKbk1TNWxlR0Z0Y0d4bExtTnZiVEJaTUJNR0J5cUdTTTQ5QWdFR0NDcUdTTTQ5QXdFSEEwSUEKQkxxSTlkWDdkOU5HbzNndUw1RlA4b3RHc2lCak43QnpkNmRHL0NheUpEZmpOUkczNFlPOHQyOTl1NkVvRlh2egpwY2pBTUd1MFVLVHJ6TWZjeU91emNNeWpYekJkTUE0R0ExVWREd0VCL3dRRUF3SUJwakFQQmdOVkhTVUVDREFHCkJnUlZIU1VBTUE4R0ExVWRFd0VCL3dRRk1BTUJBZjh3S1FZRFZSME9CQ0lFSUxITU5NUHkwTStBZUdqNk9ob1IKaDAwZ1FUQ0VYOWp1czIwdVdVVFhkbmNjTUFvR0NDcUdTTTQ5QkFNQ0EwY0FNRVFDSUY3V2wzQTExekVOcjFDbwpxR3l1M2g0ZkN1a2t0RlZ5Ry9XUEpVeWxWWGpJQWlCOUxqcFhtOUVSZ0pNZlpzakRJekNqOU00YVF1Vk45WExrClhueDB1b0t6N2c9PQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==, issuerPublicKey: CgJPVQoEUm9sZQoMRW5yb2xsbWVudElEChBSZXZvY2F0aW9uSGFuZGxlEkQKIDwI9XgGar29lWsgJQ5P++7nzIIlwWWGLEJ51ykde2A1EiCqCseWTnj4fux5l9ozepRqBhlZDfRZQFOKy755TIRikhpECiBvNt5Wcruon1yTI2OEtyActT1S0GLFcfCWXRMFykliiBIgL2P8/HJvbEI5pLb0LgoTUA1JDYYS+/MKC5irpY6t25wiRAogCAVRXVLX9SAwPD64Io0XEBFzpU0AOLnlUO84CJEN/XMSINGlHg7UFotyrB8gssFv3O56azHl+2X+k0nC2fS4IJY7IkQKILXIuSKsaLPOEnzyALvLpiW5rwRrAZZGHtkGx4CDUyY3EiDTMRCTEROrAXB/ZINA+RP3FzeUgnDLxLOes+OubkOQIyJECiA0wS8aoljJ6XkaAm6viC3+OY1WhN+zlEgfckCrIeFzixIgOKoxJtgZrFma+LPjLye6/RYlejeNegmSePueBMhOctYiRAogP3UpF6MJUiwgP1WAEdcEUmA1qBzM/pnh/P4DvTClVNsSII0ME/JUvx2G/KanqXhHSdiOPO8JMvl/oT9j86NE5acMKogBCiAkGHyPPIpfZ62j37rU+vuyhyVn3GTzHxzfENb4L81d9hIg4lovQafbr+EQ8oOgJNQYJTNoxrwt03gX0KoS351tA9AaIAprAFVW8Rj/oz5qv8EgezttuHVW6CeYxhClVaUXgkv8IiCB5IQt3kHBcfaLZ0G6T07NcgX0yEcLq/SCjjIzC+OMITJECiBjX+SptFK5yiKrp6p2unJEQzicZrOl7pcjQaYCRscHxBIgNa9BFzQiJmywsmJlMcjSexW66XrrJZzTGZIGjeuiobU6RAogiyMMfc2QIHR94xmd+qIfFFeu8C0G3x/as3asLSH63YcSIEPbCHzdb/sMxS5h42sPx+bhLbJ0UzYMapdOKilxyluFQiC+JXB0Nrg+JUDkXOO30VuNa1OWTaY+uui66lvI59+s/EogS5zQNR8QLbjptQUWittI672tran5xUvtidx7QeTSjQVSIHRZz7ANrFN/racCNVLnIrCqzxKU+QGje3+AuKvFasmy, issuerRevocationPublicKey: LS0tLS1CRUdJTiBQVUJMSUMgS0VZLS0tLS0KTUhZd0VBWUhLb1pJemowQ0FRWUZLNEVFQUNJRFlnQUVVeWpzYmtvL2kxSUg0ZEEvOURBeE15RW9YUFczVTRJRQpaMUh2K0VmWXhka1IrWWRLdzVYb09BeGRvVnl0blUzZzJNTStTZ01XK1QyZnZNVHQxOHR3QkVITVRQZnE1VHBoCmZ1VExVaitvSVJFbEFXSkNsOW44cTVRcWFLWjZaekNlCi0tLS0tRU5EIFBVQkxJQyBLRVktLS0tLQo=
2019-10-31 08:34:28,417 main INFO  HFCAClient:1542 - CA Version: 1.4.3
2019-10-31 08:34:29,098 main INFO  HFCAClient:594 - CA Name: , Version: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUNRakNDQWVtZ0F3SUJBZ0lRQTUxUzVhVjhPRktUREVrQURhL0I0VEFLQmdncWhrak9QUVFEQWpCek1Rc3cKQ1FZRFZRUUdFd0pWVXpFVE1CRUdBMVVFQ0JNS1EyRnNhV1p2Y201cFlURVdNQlFHQTFVRUJ4TU5VMkZ1SUVaeQpZVzVqYVhOamJ6RVpNQmNHQTFVRUNoTVFiM0puTWk1bGVHRnRjR3hsTG1OdmJURWNNQm9HQTFVRUF4TVRZMkV1CmIzSm5NaTVsZUdGdGNHeGxMbU52YlRBZUZ3MHhPREF5TWpVeE1qUXpNamxhRncweU9EQXlNak14TWpRek1qbGEKTUhNeEN6QUpCZ05WQkFZVEFsVlRNUk13RVFZRFZRUUlFd3BEWVd4cFptOXlibWxoTVJZd0ZBWURWUVFIRXcxVApZVzRnUm5KaGJtTnBjMk52TVJrd0Z3WURWUVFLRXhCdmNtY3lMbVY0WVcxd2JHVXVZMjl0TVJ3d0dnWURWUVFECkV4TmpZUzV2Y21jeUxtVjRZVzF3YkdVdVkyOXRNRmt3RXdZSEtvWkl6ajBDQVFZSUtvWkl6ajBEQVFjRFFnQUUKWDcxcjVqUE5WWUwrQ3FPSDFXWlhZNmJ2ZXBReUxGUkVIdFVzT3VYRmZqbGVycEd3a1BWSk5pcERaVWlmVFJTOAppbWZqK3M2dHg1cFJKZHk4YldESVZhTmZNRjB3RGdZRFZSMFBBUUgvQkFRREFnR21NQThHQTFVZEpRUUlNQVlHCkJGVWRKUUF3RHdZRFZSMFRBUUgvQkFVd0F3RUIvekFwQmdOVkhRNEVJZ1FnZXl0MlU4UlJMV3pwVTE0NEZBWTEKOVRtOWloTUw1VXJKVDM0VEczV2c4ajR3Q2dZSUtvWkl6ajBFQXdJRFJ3QXdSQUlnY20vOEFGdms3OXBaekhCdQo3dEV6WXhwTTk5QWpIbkk3bFF1Z2F5b0QrMkFDSUQ2c2dmTk56RWdSbS81aVpBRGVMQVBpb1VpQkpVcUFJV1lxCkhLYWxkWnBiCi0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K, issuerPublicKey: CgJPVQoEUm9sZQoMRW5yb2xsbWVudElEChBSZXZvY2F0aW9uSGFuZGxlEkQKIKUN1bxKXUsUNOy+bfScpF2LI3sPbJ6LX0LLIlXSuLgAEiB/qs9QkyV/5tIw2YPvFbUCsXLQk1NXOQZ+RxPM6YVtoBpECiBPeZPNPzi1vI7bw5YBvJeTOdOBO0gt/ZlIsn3uV/uPIRIgSXkrGdp/DOfpPDT2nRQh+leoXzxmB7BbO6iTZF1I6LgiRAogyvToDr9W4PgKW1cEO/LoPk9Hl0R9CgUlBTBimT3qqVISICC3xNHi9Q0P/H9DebPXiqQzKhq8uK20ZFlgLLzg1dUVIkQKIKSwLtmjfeVVsYgtGxIO+TEOwqxgc0fSKW06t2ix90C3EiABoRYyojpG96USz5VSgqhwiGUwGF1yasXK4rUFPqdHtCJECiDpPEL4uY5ua8X15HClIuj5XqmlhM27PbDiPMlU67ySQBIg2UUaB2RdOKSfzDPGPmJFzp6W1ITZhU/yHrqj1JeV5/MiRAogj0GBMlvZd7laaacSt1QPl2OLPCEele8RuW/0ZjOM0rMSIBYSJHFQzcKCtfTZSnqy8jTsUxdUaNZPOEaJwTQWwIEUKogBCiDIB3FLD2NlcDCHKUj9YiuKTzfvmKiXBaQI7nK/FQzyghIgoSQL4DaPx45ZmTSM25ZMZ0lUhLud2xFGN461WmjS9/0aINp2Tn0FVlkgq1ziFEkTjqNf0TtdpmeBdKz9NSPuiOEgIiD91wH9nsr1Luq9EppzmfeigiUYnkHqF98EjHWJuUjCGTJECiBDum1pl02apBwaDJIsIkfQ/0EcDGCmnjf5/s92xsDezxIg8c0IcNQjkf8H+OaEQ++R6Bs3XizBKzgdk1YOCGG3SvU6RAogmcVXh2wtQs6ex4T6D1GPFQeb3vX5p7LxXcoc8LNsDlcSIEPtAmlOwOU0BmodnqUvJR2kgAjymC7ciQ8z9E9Z+Up/QiB/RZnDddQpHKAFKJoNBaYqz/Jos24GNAKb+hJfrlF8N0ogkdLAh3B2lSWCpzDJliL7wATU9OIvjnZ4VmzQPX8xha1SIIQ6XWpZn5NGEMPdfoKXn262cOdbyiKjTLa+4nXEc0wy, issuerRevocationPublicKey: LS0tLS1CRUdJTiBQVUJMSUMgS0VZLS0tLS0KTUhZd0VBWUhLb1pJemowQ0FRWUZLNEVFQUNJRFlnQUU2bGtLdlNhMWY1RnJLMHZXVENieEFMbnhlRXFYZ3dKawpBYzk4bHVwWG5GQmNhMjdHWEp5Z0lqMnNLM0Q5UHd6QTVYeHQzeTRVS215SFFTUGhJU2Y1Nnh2c08xRlV6cUQ4CjlPSHpCUGpQdXhsRnl5SG5Uems2bFJRQ2dBVU1HcmZMCi0tLS0tRU5EIFBVQkxJQyBLRVktLS0tLQo=
2019-10-31 08:34:29,508 main INFO  HFCAClient:594 - CA Name: , Version: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUNRakNDQWVtZ0F3SUJBZ0lRQTUxUzVhVjhPRktUREVrQURhL0I0VEFLQmdncWhrak9QUVFEQWpCek1Rc3cKQ1FZRFZRUUdFd0pWVXpFVE1CRUdBMVVFQ0JNS1EyRnNhV1p2Y201cFlURVdNQlFHQTFVRUJ4TU5VMkZ1SUVaeQpZVzVqYVhOamJ6RVpNQmNHQTFVRUNoTVFiM0puTWk1bGVHRnRjR3hsTG1OdmJURWNNQm9HQTFVRUF4TVRZMkV1CmIzSm5NaTVsZUdGdGNHeGxMbU52YlRBZUZ3MHhPREF5TWpVeE1qUXpNamxhRncweU9EQXlNak14TWpRek1qbGEKTUhNeEN6QUpCZ05WQkFZVEFsVlRNUk13RVFZRFZRUUlFd3BEWVd4cFptOXlibWxoTVJZd0ZBWURWUVFIRXcxVApZVzRnUm5KaGJtTnBjMk52TVJrd0Z3WURWUVFLRXhCdmNtY3lMbVY0WVcxd2JHVXVZMjl0TVJ3d0dnWURWUVFECkV4TmpZUzV2Y21jeUxtVjRZVzF3YkdVdVkyOXRNRmt3RXdZSEtvWkl6ajBDQVFZSUtvWkl6ajBEQVFjRFFnQUUKWDcxcjVqUE5WWUwrQ3FPSDFXWlhZNmJ2ZXBReUxGUkVIdFVzT3VYRmZqbGVycEd3a1BWSk5pcERaVWlmVFJTOAppbWZqK3M2dHg1cFJKZHk4YldESVZhTmZNRjB3RGdZRFZSMFBBUUgvQkFRREFnR21NQThHQTFVZEpRUUlNQVlHCkJGVWRKUUF3RHdZRFZSMFRBUUgvQkFVd0F3RUIvekFwQmdOVkhRNEVJZ1FnZXl0MlU4UlJMV3pwVTE0NEZBWTEKOVRtOWloTUw1VXJKVDM0VEczV2c4ajR3Q2dZSUtvWkl6ajBFQXdJRFJ3QXdSQUlnY20vOEFGdms3OXBaekhCdQo3dEV6WXhwTTk5QWpIbkk3bFF1Z2F5b0QrMkFDSUQ2c2dmTk56RWdSbS81aVpBRGVMQVBpb1VpQkpVcUFJV1lxCkhLYWxkWnBiCi0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K, issuerPublicKey: CgJPVQoEUm9sZQoMRW5yb2xsbWVudElEChBSZXZvY2F0aW9uSGFuZGxlEkQKIKUN1bxKXUsUNOy+bfScpF2LI3sPbJ6LX0LLIlXSuLgAEiB/qs9QkyV/5tIw2YPvFbUCsXLQk1NXOQZ+RxPM6YVtoBpECiBPeZPNPzi1vI7bw5YBvJeTOdOBO0gt/ZlIsn3uV/uPIRIgSXkrGdp/DOfpPDT2nRQh+leoXzxmB7BbO6iTZF1I6LgiRAogyvToDr9W4PgKW1cEO/LoPk9Hl0R9CgUlBTBimT3qqVISICC3xNHi9Q0P/H9DebPXiqQzKhq8uK20ZFlgLLzg1dUVIkQKIKSwLtmjfeVVsYgtGxIO+TEOwqxgc0fSKW06t2ix90C3EiABoRYyojpG96USz5VSgqhwiGUwGF1yasXK4rUFPqdHtCJECiDpPEL4uY5ua8X15HClIuj5XqmlhM27PbDiPMlU67ySQBIg2UUaB2RdOKSfzDPGPmJFzp6W1ITZhU/yHrqj1JeV5/MiRAogj0GBMlvZd7laaacSt1QPl2OLPCEele8RuW/0ZjOM0rMSIBYSJHFQzcKCtfTZSnqy8jTsUxdUaNZPOEaJwTQWwIEUKogBCiDIB3FLD2NlcDCHKUj9YiuKTzfvmKiXBaQI7nK/FQzyghIgoSQL4DaPx45ZmTSM25ZMZ0lUhLud2xFGN461WmjS9/0aINp2Tn0FVlkgq1ziFEkTjqNf0TtdpmeBdKz9NSPuiOEgIiD91wH9nsr1Luq9EppzmfeigiUYnkHqF98EjHWJuUjCGTJECiBDum1pl02apBwaDJIsIkfQ/0EcDGCmnjf5/s92xsDezxIg8c0IcNQjkf8H+OaEQ++R6Bs3XizBKzgdk1YOCGG3SvU6RAogmcVXh2wtQs6ex4T6D1GPFQeb3vX5p7LxXcoc8LNsDlcSIEPtAmlOwOU0BmodnqUvJR2kgAjymC7ciQ8z9E9Z+Up/QiB/RZnDddQpHKAFKJoNBaYqz/Jos24GNAKb+hJfrlF8N0ogkdLAh3B2lSWCpzDJliL7wATU9OIvjnZ4VmzQPX8xha1SIIQ6XWpZn5NGEMPdfoKXn262cOdbyiKjTLa+4nXEc0wy, issuerRevocationPublicKey: LS0tLS1CRUdJTiBQVUJMSUMgS0VZLS0tLS0KTUhZd0VBWUhLb1pJemowQ0FRWUZLNEVFQUNJRFlnQUU2bGtLdlNhMWY1RnJLMHZXVENieEFMbnhlRXFYZ3dKawpBYzk4bHVwWG5GQmNhMjdHWEp5Z0lqMnNLM0Q5UHd6QTVYeHQzeTRVS215SFFTUGhJU2Y1Nnh2c08xRlV6cUQ4CjlPSHpCUGpQdXhsRnl5SG5Uems2bFJRQ2dBVU1HcmZMCi0tLS0tRU5EIFBVQkxJQyBLRVktLS0tLQo=
2019-10-31 08:34:29,509 main INFO  HFCAClient:1542 - CA Version: 1.4.3
2019-10-31 08:34:36,610 main INFO  Channel:1259 - Channel Channel{id: 1, name: foo} eventThread started shutdown: false  thread: null 
Checking instantiated chaincode: cc-NetworkConfigTest-001, at version: 1, on peer: peer0.org1.example.com
deployChaincode - enter
deployChaincode - channelName = foo
Creating install proposal
Sending install proposal
2019-10-31 08:34:36,764 main INFO  InstallProposalBuilder:243 - Installing 'cc-NetworkConfigTest-001::github.com/example_cc::1' language Go chaincode from directory: 'D:\code\java\fabric-sdk-java\src\test\fixture\sdkintegration\gocc\sample1\src\github.com\example_cc' with source location: 'src\github.com\example_cc'. chaincodePath:'github.com/example_cc'
Successful install proposal response Txid: 722e80d8ad564143779e024adf4a0fed311f65a4b7e54ce0c2ad894589cd6a39 from peer peer0.org1.example.com
Successful install proposal response Txid: 722e80d8ad564143779e024adf4a0fed311f65a4b7e54ce0c2ad894589cd6a39 from peer peer1.org1.example.com
Received 2 install proposal responses. Successful+verified: 2 . Failed: 0
Sending instantiateProposalRequest to all peers...
Succesful instantiate proposal response Txid: 174052c470cc369335033a1c44c956c9f9941de7b2012c95d11e44d4c3a74776 from peer peer0.org1.example.com
Succesful instantiate proposal response Txid: 174052c470cc369335033a1c44c956c9f9941de7b2012c95d11e44d4c3a74776 from peer peer1.org1.example.com
Received 2 instantiate proposal responses. Successful+verified: 2 . Failed: 0
Sending instantiateTransaction to orderer...
calling get...
get done...
Finished instantiate transaction with transaction id 174052c470cc369335033a1c44c956c9f9941de7b2012c95d11e44d4c3a74776
2019-10-31 08:34:57,924 main INFO  Channel:1259 - Channel Channel{id: 11, name: foo} eventThread started shutdown: false  thread: null 
Running testUpdate1 - Channel foo
Now query chaincode on channel foo for the current value of b
Query payload of b from peer peer0.org1.example.com returned 999
Query payload of b from peer peer1.org1.example.com returned 999
Original value = 999
sending transaction proposal to all peers with arguments: move(a,b,5)
Successful transaction proposal response Txid: cfeebeb5ecba13da6d0882782a0572df7f8b2604759c7c2e86c5e4b2d0707b58 from peer peer0.org1.example.com
Successful transaction proposal response Txid: cfeebeb5ecba13da6d0882782a0572df7f8b2604759c7c2e86c5e4b2d0707b58 from peer peer1.org1.example.com
Received 2 transaction proposal responses. Successful+verified: 2 . Failed: 0
Successfully received transaction proposal responses.
Sending chaincode transaction(move a,b,5) to orderer.
Now query chaincode on channel foo for the value of b expecting to see: 1004
Now query chaincode on channel foo for the current value of b
Query payload of b from peer peer0.org1.example.com returned 1004
Query payload of b from peer peer1.org1.example.com returned 1004
sending transaction proposal to all peers with arguments: move(b,a,5)
Successful transaction proposal response Txid: 19ee71e5b8f3d3e6ddd65605afda14ecc6b8e32e3077bad82b02b12b950449ac from peer peer0.org1.example.com
Successful transaction proposal response Txid: 19ee71e5b8f3d3e6ddd65605afda14ecc6b8e32e3077bad82b02b12b950449ac from peer peer1.org1.example.com
Received 2 transaction proposal responses. Successful+verified: 2 . Failed: 0
Successfully received transaction proposal responses.
Sending chaincode transaction(move b,a,5) to orderer.
Now query chaincode on channel foo for the value of b expecting to see: 999
Now query chaincode on channel foo for the current value of b
Query payload of b from peer peer0.org1.example.com returned 999
Query payload of b from peer peer1.org1.example.com returned 999
testUpdate1 - done
That's all folks!
2019-10-31 08:35:02,999 pool-4-thread-1 INFO  Channel:5988 - Channel foo eventThread shutting down. shutdown: true  thread: pool-4-thread-1 
Tests run: 1, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 39.593 sec - in org.hyperledger.fabric.sdkintegration.NetworkConfigIT

Results :

Tests run: 1, Failures: 0, Errors: 0, Skipped: 0

[INFO] 
[INFO] --- jacoco-maven-plugin:0.8.2:report (post-unit-test) @ fabric-sdk-java ---
[INFO] Loading execution data file D:\code\java\fabric-sdk-java\target\coverage-reports\jacoco-ut.exec
[INFO] Analyzed bundle 'fabric-java-sdk' with 252 classes
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  01:29 min
[INFO] Finished at: 2019-10-31T16:35:05+08:00
[INFO] ------------------------------------------------------------------------

```

### 5. 停止master和slave机器上的docker
```shell
#停止命令
docker-compose down
```
