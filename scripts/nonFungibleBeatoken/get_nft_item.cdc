import NonFungibleBeatoken from "../../contracts/NonFungibleBeatoken.cdc"

pub fun main(address: Address, itemID: UInt64): NonFungibleBeatoken.Metadata? {
  if let collection = getAccount(address).getCapability<&{NonFungibleBeatoken.NFTReceiver}>(/public/NFTReceiver).borrow() {
    return collection.borrowNFT(id: itemID).metadata
  }
  return nil
}
