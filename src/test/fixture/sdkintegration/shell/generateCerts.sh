


# Generates Org certs using cryptogen tool
function generateCerts() {
  which cryptogen
  if [ "$?" -ne 0 ]; then
    echo "cryptogen tool not found. exiting"
    exit 1
  fi
  echo
  echo "##########################################################"
  echo "##### Generate certificates using cryptogen tool #########"
  echo "##########################################################"

  if [ -d "crypto-config" ]; then
    rm -Rf crypto-config
  fi
  set -x
  cryptogen generate --config=./crypto-config.yaml
  res=$?
  set +x
  if [ $res -ne 0 ]; then
    echo "Failed to generate certificates..."
    exit 1
  fi
  echo
  echo "##########################################################"
  echo "##### Generate certificates completed            #########"
  echo "##########################################################"
}

export PATH=${PWD}/../bin:${PWD}:$PATH
generateCerts
rm -rf ../e2e-2Orgs/v1.3/
mv crypto-config ../e2e-2Orgs/v1.3/