// SPDX-License-Identifier: UNLICENSED
import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import NonFungibleBeatoken from "../../contracts/NonFungibleBeatoken.cdc"

transaction(recipient: Address, name: String, ipfs_hash: String, token_uri: String, description: String) {

    let minter: &NonFungibleBeatoken.NFTMinter

    prepare(signer: AuthAccount) {
        self.minter = signer.borrow<&NonFungibleBeatoken.NFTMinter>(from: NonFungibleBeatoken.storageMinter)
            ?? panic("Could not borrow a reference to the NFT minter")
    }

    execute {
        let receiver = getAccount(recipient)
            .getCapability(NonFungibleBeatoken.publicReceiver)!
            .borrow<&{NonFungibleToken.CollectionPublic}>()
            ?? panic("Could not get receiver reference to the NFT Collection")

        self.minter.mintNFT(recipient: receiver, name: name, ipfs_hash: ipfs_hash, token_uri: token_uri, description: description)
    }
}
