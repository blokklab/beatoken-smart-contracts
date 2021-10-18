import NonFungibleToken from "./NonFungibleToken.cdc"

pub contract NonFungibleBeatoken: NonFungibleToken {

    pub var totalSupply: UInt64

    pub let storageCollection: StoragePath
    pub let publicNFTReceiver: PublicPath
    pub let storageNFTMinter: StoragePath

    pub event ContractInitialized()
    pub event Withdraw(id: UInt64, from: Address?)
    pub event Deposit(id: UInt64, to: Address?)
    pub event CreatedNft(id: UInt64)

    pub struct Metadata {
        pub let name: String
        pub let ipfs_hash: String
        pub let token_uri: String
        pub let description: String

        init(name: String, 
            ipfs_hash:String, 
            token_uri:String,
            description:String) {

            self.name=name
            self.ipfs_hash=ipfs_hash
            self.token_uri=token_uri
            self.description=description
        }
    }

    pub resource NFT: NonFungibleToken.INFT {

        pub let id: UInt64
        pub let metadata: Metadata

        init(initID: UInt64, metadata: Metadata) {
            self.id = initID
            self.metadata = metadata
        }
    }

    pub resource Collection: NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic {
        pub var ownedNFTs: @{UInt64: NonFungibleToken.NFT}

        init () {
            self.ownedNFTs <- {}
        }

        pub fun withdraw(withdrawID: UInt64): @NonFungibleToken.NFT {
            let token <- self.ownedNFTs.remove(key: withdrawID) ?? panic("missing NFT")

            return <-token
        }

        pub fun deposit(token: @NonFungibleToken.NFT) {
            let token <- token as! @NFT
            let oldToken <- self.ownedNFTs[token.id] <- token
            destroy oldToken
        }

        pub fun getIDs(): [UInt64] {
            return self.ownedNFTs.keys
        }

        pub fun borrowNFT(id: UInt64): &NonFungibleToken.NFT {
            return &self.ownedNFTs[id] as &NonFungibleToken.NFT
        }

        destroy() {
            destroy self.ownedNFTs
        }
    }

    pub fun createEmptyCollection(): @Collection {
        return <- create Collection()
    }

    pub resource NFTMinter {

        pub fun mintNFT(recipient: &{NonFungibleToken.CollectionPublic}, name: String, ipfs_hash: String, token_uri: String, description: String) {
            let id = NonFungibleBeatoken.totalSupply
            let newNFT <- create NFT(
                initID: id,
                metadata: Metadata(
                  name: name,
                  ipfs_hash: ipfs_hash,
                  token_uri: token_uri.concat(id.toString()),
                  description: description
                )
            )

            recipient.deposit(token: <-newNFT)

            NonFungibleBeatoken.totalSupply = id + (1 as UInt64)

            emit CreatedNft(id: id)
        }
    }

    init() {
        self.totalSupply = 1;

        // Define paths
        self.storageCollection = /storage/NFTCollection
        self.publicNFTReceiver = /public/NFTReceiver
        self.storageNFTMinter = /storage/NFTMinter

        // Create, store and explose capability for collection
        let collection <- self.createEmptyCollection()
        self.account.save(<- collection, to: self.storageCollection )
        self.account.link<&{NonFungibleToken.Receiver}>(self.publicNFTReceiver, target: self.storageCollection)
        
        self.account.save(<-create NFTMinter(), to: self.storageNFTMinter )
    }
}
