import FungibleBeatoken from "../../contracts/FungibleBeatoken.cdc"
import NonFungibleBeatoken from "../../contracts/NonFungibleBeatoken.cdc"
import MarketplaceBeatoken from "../../contracts/MarketplaceBeatoken.cdc"

transaction {
    prepare(acct: AuthAccount) {
        if acct.borrow<&MarketplaceBeatoken.SaleCollection>(from: /storage/NFTSale) == nil {
            let sale <- MarketplaceBeatoken.createSaleCollection(
                ownerCollection: acct.getCapability<&{NonFungibleBeatoken.NFTReceiver}>(/public/NFTReceiver),
                ownerVault: acct.getCapability<&{FungibleBeatoken.Receiver}>(/public/MainReceiver)
            )

            acct.save<@MarketplaceBeatoken.SaleCollection>(<-sale, to: /storage/NFTSale)

            acct.link<&MarketplaceBeatoken.SaleCollection{MarketplaceBeatoken.SalePublic}>(/public/NFTSale, target: /storage/NFTSale)
        }
    }
}
