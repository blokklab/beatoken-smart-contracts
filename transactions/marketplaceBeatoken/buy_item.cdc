// SPDX-License-Identifier: UNLICENSED
import FungibleBeatoken from "../../contracts/FungibleBeatoken.cdc"
import NonFungibleBeatoken from "../../contracts/NonFungibleBeatoken.cdc"
import MarketplaceBeatoken from "../../contracts/MarketplaceBeatoken.cdc"

transaction(ownerNft: Address, buyItemId: UInt64, buyItemPrice: UFix64) {
    prepare(acct: AuthAccount) {
        if acct.borrow<&NonFungibleBeatoken.Collection>(from: NonFungibleBeatoken.storageCollection) == nil {
            acct.save<@NonFungibleBeatoken.Collection>(<-NonFungibleBeatoken.createEmptyCollection(), to: NonFungibleBeatoken.storageCollection)
            acct.link<&NonFungibleBeatoken.Collection>(NonFungibleBeatoken.publicReceiver, target: NonFungibleBeatoken.storageCollection)
        }

        let collectionRef = acct.borrow<&NonFungibleBeatoken.Collection>(from: NonFungibleBeatoken.storageCollection)
            ?? panic("Could not borrow owner's nft collection reference")

        let vaultRef = acct.borrow<&FungibleBeatoken.Vault>(from: FungibleBeatoken.vaultStoragePath)
            ?? panic("Could not borrow owner's vault reference")

        let saleRef = getAccount(ownerNft).getCapability<&AnyResource{MarketplaceBeatoken.SalePublic}>(/public/NFTSale)
            .borrow()
            ?? panic("Could not borrow seller's sale reference")

        let temporaryVault <- vaultRef.withdraw(amount: buyItemPrice) as! @FungibleBeatoken.Vault

        saleRef.purchase(tokenID: buyItemId, recipient: collectionRef, buyTokens: <-temporaryVault)
    }
}
 