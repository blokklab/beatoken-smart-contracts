import NonFungibleBeatoken from "../../contracts/NonFungibleBeatoken.cdc"
import MarketplaceBeatoken from "../../contracts/MarketplaceBeatoken.cdc"

transaction(nftId: UInt64) {
    let market: &MarketplaceBeatoken.SaleCollection
    let collectionRef: &AnyResource{NonFungibleBeatoken.NFTReceiver}

    prepare(acct: AuthAccount) {
        self.market = acct.borrow<&MarketplaceBeatoken.SaleCollection>(from: /storage/NFTSale)
        ?? panic("Could not borrow from sale in storage")

        self.collectionRef = acct.borrow<&AnyResource{NonFungibleBeatoken.NFTReceiver}>(from: /storage/NFTCollection)!
    }

    execute {
        self.market.cancelSale(tokenID: nftId, recipient: self.collectionRef)
    }
}
