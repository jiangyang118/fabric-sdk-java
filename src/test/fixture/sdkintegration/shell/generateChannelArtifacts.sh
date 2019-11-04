# default consensus type
CONSENSUS_TYPE="solo"
# system channel name defaults to "byfn-sys-channel"
SYS_CHANNEL="byfn-sys-channel"

# Generate orderer genesis block, channel configuration transaction and
# anchor peer update transactions
function generateChannelArtifacts() {
  which configtxgen
  if [ "$?" -ne 0 ]; then
    echo "configtxgen tool not found. exiting"
    exit 1
  fi

  echo "##########################################################"
  echo "#########  Generating Orderer Genesis block ##############"
  echo "##########################################################"
  # Note: For some unknown reason (at least for now) the block file can't be
  # named orderer.genesis.block or the orderer will fail to launch!
  echo "CONSENSUS_TYPE="$CONSENSUS_TYPE
  set -x
  if [ "$CONSENSUS_TYPE" == "solo" ]; then
    configtxgen -profile TwoOrgsOrdererGenesis -channelID $SYS_CHANNEL -outputBlock ./orderer.block
  elif [ "$CONSENSUS_TYPE" == "kafka" ]; then
    configtxgen -profile SampleDevModeKafka -channelID $SYS_CHANNEL -outputBlock ./orderer.block
  elif [ "$CONSENSUS_TYPE" == "etcdraft" ]; then
    configtxgen -profile SampleMultiNodeEtcdRaft -channelID $SYS_CHANNEL -outputBlock ./orderer.block
  else
    set +x
    echo "unrecognized CONSESUS_TYPE='$CONSENSUS_TYPE'. exiting"
    exit 1
  fi
  res=$?
  set +x
  if [ $res -ne 0 ]; then
    echo "Failed to generate orderer genesis block..."
    exit 1
  fi
  echo
  echo "#################################################################"
  echo "### Generating channel configuration transaction 'channel.tx' ###"
  echo "#################################################################"
  set -x
  configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/bar.tx -channelID bar
  configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/foo.tx -channelID foo
  res=$?
  set +x
  if [ $res -ne 0 ]; then
    echo "Failed to generate channel configuration transaction..."
    exit 1
  fi

  echo
}

export PATH=${PWD}/../bin:${PWD}:$PATH
generateChannelArtifacts

mv orderer.block ../e2e-2Orgs/v1.3/
mv bar.tx ../e2e-2Orgs/v1.3/
mv foo.tx ../e2e-2Orgs/v1.3/
