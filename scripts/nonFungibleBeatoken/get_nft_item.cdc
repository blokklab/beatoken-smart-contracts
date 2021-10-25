// SPDX-License-Identifier: UNLICENSED
import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import NonFungibleBeatoken from "../../contracts/NonFungibleBeatoken.cdc"

pub fun main(address: Address, itemID: UInt64): &NonFungibleToken.NFT? {
  if let collection = getAccount(address).getCapability<&NonFungibleBeatoken.Collection{NonFungibleToken.CollectionPublic, NonFungibleBeatoken.BeatokenCollectionPublic}>(NonFungibleBeatoken.publicReceiver).borrow() {
    return collection.borrowNFT(id: itemID)
  }
  return nil
}
