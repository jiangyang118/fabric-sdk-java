
# 需要提替换244.yaml  140.yaml network_configs.yaml
function replacePrivateKey() {
  # sed on MacOSX does not support -i flag with a null extension. We will use
  # 't' for our back-up's extension and delete it at the end of the function
  ARCH=$(uname -s | grep Darwin)
  if [ "$ARCH" == "Darwin" ]; then
    OPTS="-it"
  else
    OPTS="-i"
  fi

  # The next steps will replace the template's contents with the
  # actual values of the private key file names for the two CAs.
  CURRENT_DIR=$PWD
  cd ../e2e-2Orgs/v1.3/crypto-config/peerOrganizations/org1.esunego.com/ca/
  PRIV_KEY=$(ls *_sk)
  cd "$CURRENT_DIR"
  sed $OPTS "s/CA0_PRIVATE_KEY/${PRIV_KEY}/g" ../244.yaml
  
  cd ../e2e-2Orgs/v1.3/crypto-config/peerOrganizations/org2.esunego.com/ca/
  PRIV_KEY=$(ls *_sk)
  cd "$CURRENT_DIR"
  sed $OPTS "s/CA1_PRIVATE_KEY/${PRIV_KEY}/g" ../140.yaml


}

replacePrivateKey