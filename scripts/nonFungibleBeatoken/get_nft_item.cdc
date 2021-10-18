import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import NonFungibleBeatoken from "../../contracts/NonFungibleBeatoken.cdc"

pub fun main(address: Address, itemID: UInt64): NonFungibleBeatoken.Metadata? {
  if let collection = getAccount(address).getCapability<&NonFungibleBeatoken.Collection{NonFungibleToken.CollectionPublic}>(NonFungibleBeatoken.publicNFTReceiver).borrow() {
    return collection.borrowNFT(id: itemID).metadata
  }
  return nil
}
