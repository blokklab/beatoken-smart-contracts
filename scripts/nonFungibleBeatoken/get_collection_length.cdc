import NonFungibleBeatoken from "../../contracts/NonFungibleBeatoken.cdc"

pub fun main(address: Address): Int {
    let collectionRef = getAccount(address).getCapability<&{NonFungibleBeatoken.NFTReceiver}>(/public/NFTReceiver)
        .borrow()
        ?? panic("Could not borrow capability from public collection")

    return collectionRef.getIDs().length
}
