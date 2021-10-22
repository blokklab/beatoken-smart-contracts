import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import NonFungibleBeatoken from "../../contracts/NonFungibleBeatoken.cdc"

transaction(recipient: Address, withdrawID: UInt64) {
    prepare(signer: AuthAccount) {

        let collectionRef = signer.borrow<&NonFungibleBeatoken.Collection>(from: NonFungibleBeatoken.storageCollection)
            ?? panic("Could not borrow a reference to the owner's collection")

        let depositRef = getAccount(recipient).getCapability(NonFungibleBeatoken.publicReceiver)!
            .borrow<&{NonFungibleToken.CollectionPublic}>()!
            
        let nft <- collectionRef.withdraw(withdrawID: withdrawID)

        depositRef.deposit(token: <-nft)
    }
}

