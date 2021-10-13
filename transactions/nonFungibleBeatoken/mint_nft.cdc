import NonFungibleBeatoken from "../../contracts/NonFungibleBeatoken.cdc"

transaction(recipient: Address, name: String, ipfs_hash: String, token_uri: String, description: String) {

    let minter: &NonFungibleBeatoken.NFTMinter

    prepare(signer: AuthAccount) {
        self.minter = signer.borrow<&NonFungibleBeatoken.NFTMinter>(from: /storage/NFTMinter)
            ?? panic("Could not borrow a reference to the NFT minter")
    }

    execute {
        let receiver = getAccount(recipient).getCapability<&{NonFungibleBeatoken.NFTReceiver}>(/public/NFTReceiver)!
            .borrow()
            ?? panic("Could not get receiver reference to the NFT Collection")

        self.minter.mintNFT(recipient: receiver, name: name, ipfs_hash: ipfs_hash, token_uri: token_uri, description: description)
    }
}
