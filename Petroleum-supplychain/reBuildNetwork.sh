# If you have made changes in configtx.yaml  ,
# then you have to rebuild the network from scratch for the changes (policies) to apply .

docker-compose down -v
echo " Network has shut down and all channels , ledger data has been deleted"

rm -rf crypto-config channel-artifacts system-genesis-block
echo "Removed the crypto-config , channel-artifacts , system-genesis-block files"

cryptogen generate --config=./config/crypto-config.yaml
echo "Generated crypto-config.yaml"

configtxgen -profile SupplyChainGenesis -channelID system-channel -outputBlock ./channel-artifacts/genesis.block --configPath ./config
echo " Generated  => channel-artifacts/genesis.block "

configtxgen \
  -profile SupplyChainChannel \
  -outputCreateChannelTx ./channel-artifacts/supplychannel.tx \
  -channelID supplychannel \
  --configPath ./config


configtxgen \
  -profile SupplyChainChannel \
  -outputAnchorPeersUpdate ./channel-artifacts/Org1Anchors.tx \
  -channelID supplychannel \
  -asOrg Org1MSP \
  --configPath ./config

configtxgen \
  -profile SupplyChainChannel \
  -outputAnchorPeersUpdate ./channel-artifacts/Org2Anchors.tx \
  -channelID supplychannel \
  -asOrg Org2MSP \
  --configPath ./config

configtxgen \
  -profile SupplyChainChannel \
  -outputAnchorPeersUpdate ./channel-artifacts/Org3Anchors.tx \
  -channelID supplychannel \
  -asOrg Org3MSP \
  --configPath ./config

echo "Generated the anchor peers (gossip communication) in channel-artifacts folder => supplychannel.tx , Org1Anchors.tx , Org2Anchors.tx , Org3Anchors.tx "

docker-compose up -d
echo "Network is up"

docker exec -it cli bash
echo "Bash is open"

echo "Creating channel"
peer channel create \
  -o orderer.example.com:7050 \
  --ordererTLSHostnameOverride orderer.example.com \
  -c supplychannel \
  -f ./channel-artifacts/supplychannel.tx \
  --outputBlock ./supplychannel.block \
  --tls --cafile $ORDERER_CA
echo " supplychannel.block created inside channel-artifacts"

echo "Joining all the peers in the channel and submitted anchor peer updates to channel"

source setEnvOrg1.sh
peer channel join -b ./channel-artifacts/supplychannel.block

peer channel update -o orderer.example.com:7050 \
  --ordererTLSHostnameOverride orderer.example.com \
  -c supplychannel -f ./channel-artifacts/Org1Anchors.tx \
  --tls --cafile $ORDERER_CA

source setEnvOrg2.sh
peer channel join -b ./channel-artifacts/supplychannel.block
peer channel update -o orderer.example.com:7050 \
  --ordererTLSHostnameOverride orderer.example.com \
  -c supplychannel -f ./channel-artifacts/Org2Anchors.tx \
  --tls --cafile $ORDERER_CA

source setEnvOrg3.sh
peer channel join -b ./channel-artifacts/supplychannel.block
peer channel update -o orderer.example.com:7050 \
  --ordererTLSHostnameOverride orderer.example.com \
  -c supplychannel -f ./channel-artifacts/Org3Anchors.tx \
  --tls --cafile $ORDERER_CA

echo " Joined all the peers of all organizations and updated the channel"

echo " Install the chaincode in all the peers"
exit 
docker cp petroleum.tar.gz cli:/opt/gopath/src/github.com/

echo "Copied the petroleum.tar.gz file inside the container"

docker exec -it cli bash
cd /opt/gopath/src/github.com/


source setEnvOrg1.sh
peer lifecycle chaincode install petroleum.tar.gz
source setEnvOrg2.sh
peer lifecycle chaincode install petroleum.tar.gz
source setEnvOrg3.sh
peer lifecycle chaincode install petroleum.tar.gz

echo " Installed the chaincode in all the oarganizations "
echo " [Chaincode code package identifier: petroleum_1:d9338f2d47ba2461375abe3e477983b7afadba9e3458127ba8a1f32a52e73f31]"
echo " The identifier will be the above if you havent chnage the petroleum.tar.gz file"
echo " If you have changed the chaincode  , then generate a new tar.gz file from the chaincode file and install it in the organizations and use that package identifier for approving , committing , querying"

source setEnvOrg1.sh
peer lifecycle chaincode approveformyorg \
  --orderer orderer.example.com:7050 \
  --channelID supplychannel \
  --name petroleum_1 \
  --version 1.0 \
  --package-id petroleum_1:d9338f2d47ba2461375abe3e477983b7afadba9e3458127ba8a1f32a52e73f31 \
  --sequence 1 \
  --tls --cafile $ORDERER_CA

source setEnvOrg2.sh
peer lifecycle chaincode approveformyorg \
  --orderer orderer.example.com:7050 \
  --channelID supplychannel \
  --name petroleum_1 \
  --version 1.0 \
  --package-id petroleum_1:d9338f2d47ba2461375abe3e477983b7afadba9e3458127ba8a1f32a52e73f31 \
  --sequence 1 \
  --tls --cafile $ORDERER_CA


source setEnvOrg3.sh
peer lifecycle chaincode approveformyorg \
  --orderer orderer.example.com:7050 \
  --channelID supplychannel \
  --name petroleum_1 \
  --version 1.0 \
  --package-id petroleum_1:d9338f2d47ba2461375abe3e477983b7afadba9e3458127ba8a1f32a52e73f31 \
  --sequence 1 \
  --tls --cafile $ORDERER_CA

echo " Approved the chaincode in all the oarganizations "


