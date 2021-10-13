pub contract NonFungibleBeatoken {

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

    pub resource NFT {
        pub let id: UInt64
        pub let metadata: Metadata

        init(initID: UInt64, metadata: Metadata) {
              self.id = initID
              self.metadata = metadata
        }
    }

    pub resource interface NFTReceiver {
        pub fun deposit(token: @NFT)
        pub fun getIDs(): [UInt64]
        pub fun borrowNFT(id: UInt64): &NonFungibleBeatoken.NFT
        pub fun idExists(id: UInt64): Bool
    }

    pub resource Collection: NFTReceiver {
        pub var ownedNFTs: @{UInt64: NFT}

        init () {
            self.ownedNFTs <- {}
        }

        pub fun withdraw(withdrawID: UInt64): @NFT {
            let token <- self.ownedNFTs.remove(key: withdrawID)!

            return <-token
        }

        pub fun deposit(token: @NFT) {
            let oldToken <- self.ownedNFTs[token.id] <- token
            destroy oldToken
        }

        pub fun idExists(id: UInt64): Bool {
            return self.ownedNFTs[id] != nil
        }

        pub fun getIDs(): [UInt64] {
            return self.ownedNFTs.keys
        }

        pub fun borrowNFT(id: UInt64): &NonFungibleBeatoken.NFT {
            return &self.ownedNFTs[id] as &NonFungibleBeatoken.NFT
        }

        destroy() {
            destroy self.ownedNFTs
        }
    }

    pub fun createEmptyCollection(): @Collection {
        return <- create Collection()
    }

    pub resource NFTMinter {
        pub var idCount: UInt64

        init() {
            self.idCount = 1
        }

        pub fun mintNFT(recipient: &AnyResource{NFTReceiver}, name: String, ipfs_hash: String, token_uri: String, description: String) {
            let id = self.idCount
            var newNFT <- create NFT(
                initID: id,
                metadata: Metadata(
                  name: name,
                  ipfs_hash: ipfs_hash,
                  token_uri: token_uri.concat(id.toString()),
                  description: description
                )
            )

            recipient.deposit(token: <-newNFT)

            self.idCount = self.idCount + 1 as UInt64

            emit CreatedNft(id: id)
        }
    }

    init() {
        self.account.save(<-self.createEmptyCollection(), to: /storage/NFTCollection)
        self.account.link<&{NFTReceiver}>(/public/NFTReceiver, target: /storage/NFTCollection)
        self.account.save(<-create NFTMinter(), to: /storage/NFTMinter)
    }
}
