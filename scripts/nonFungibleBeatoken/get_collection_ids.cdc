import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import NonFungibleBeatoken from "../../contracts/NonFungibleBeatoken.cdc"

pub fun main(address: Address): [UInt64] {
    let collectionRef = getAccount(address).getCapability(NonFungibleBeatoken.publicNFTReceiver)!!
        .borrow<&{NonFungibleToken.CollectionPublic}>()
        ?? panic("Could not borrow capability from public collection")

    return collectionRef.getIDs()
}
