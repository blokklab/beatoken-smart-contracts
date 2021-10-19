import NonFungibleBeatoken from "../../contracts/NonFungibleBeatoken.cdc"
import MarketplaceBeatoken from "../../contracts/MarketplaceBeatoken.cdc"

transaction(nftId: UInt64) {
    let market: &MarketplaceBeatoken.SaleCollection
    let collectionRef: &NonFungibleBeatoken.Collection
    
    prepare(acct: AuthAccount) {
        self.market = acct.borrow<&MarketplaceBeatoken.SaleCollection>(from: /storage/NFTSale)
        ?? panic("Could not borrow from sale in storage")

        self.collectionRef = acct.borrow<&NonFungibleBeatoken.Collection>(from: NonFungibleBeatoken.storageCollection)!
    }

    execute {
        self.market.cancelSale(tokenID: nftId, recipient: self.collectionRef)
    }
}
