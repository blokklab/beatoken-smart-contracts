import FungibleBeatoken from "../../contracts/FungibleBeatoken.cdc"
import NonFungibleBeatoken from "../../contracts/NonFungibleBeatoken.cdc"
import MarketplaceBeatoken from "../../contracts/MarketplaceBeatoken.cdc"

transaction(saleItemID: UInt64, saleItemPrice: UFix64) {
    prepare(acct: AuthAccount) {
        let collectionRef = acct.borrow<&NonFungibleBeatoken.Collection>(from: /storage/NFTCollection)
            ?? panic("Could not borrow owner's nft collection reference")

        let token <- collectionRef.withdraw(withdrawID: saleItemID)
        let sale = acct.borrow<&MarketplaceBeatoken.SaleCollection>(from: /storage/NFTSale)
            ?? panic("Could not borrow from sale in storage")

        sale.listForSale(token: <-token, price: saleItemPrice)
    }
}
