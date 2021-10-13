import FungibleBeatoken from "../../contracts/FungibleBeatoken.cdc"
import NonFungibleBeatoken from "../../contracts/NonFungibleBeatoken.cdc"
import MarketplaceBeatoken from "../../contracts/MarketplaceBeatoken.cdc"

transaction(ownerNft: Address, buyItemId: UInt64, buyItemPrice: UFix64) {
    prepare(acct: AuthAccount) {
        if acct.borrow<&AnyResource{NonFungibleBeatoken.NFTReceiver}>(from: /storage/NFTCollection) == nil {
            acct.save<@NonFungibleBeatoken.Collection>(<-NonFungibleBeatoken.createEmptyCollection(), to: /storage/NFTCollection)
            acct.link<&{NonFungibleBeatoken.NFTReceiver}>(/public/NFTReceiver, target: /storage/NFTCollection)
        }

        let collectionRef = acct.borrow<&AnyResource{NonFungibleBeatoken.NFTReceiver}>(from: /storage/NFTCollection)
            ?? panic("No nft storage")

        let vaultRef = acct.borrow<&FungibleBeatoken.Vault>(from: /storage/MainVault)
            ?? panic("Could not borrow owner's vault reference")

        let saleRef = getAccount(ownerNft).getCapability<&AnyResource{MarketplaceBeatoken.SalePublic}>(/public/NFTSale)
            .borrow()
            ?? panic("Could not borrow seller's sale reference")

        let temporaryVault <- vaultRef.withdraw(amount: buyItemPrice)
        saleRef.purchase(tokenID: buyItemId, recipient: collectionRef, buyTokens: <-temporaryVault)
    }
}
