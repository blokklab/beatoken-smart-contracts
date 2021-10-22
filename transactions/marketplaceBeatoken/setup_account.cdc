// SPDX-License-Identifier: UNLICENSED
import FungibleBeatoken from "../../contracts/FungibleBeatoken.cdc"
import NonFungibleBeatoken from "../../contracts/NonFungibleBeatoken.cdc"
import MarketplaceBeatoken from "../../contracts/MarketplaceBeatoken.cdc"

transaction {
    prepare(acct: AuthAccount) {
        if acct.borrow<&MarketplaceBeatoken.SaleCollection>(from: MarketplaceBeatoken.storageSale) == nil {
            
            acct.link<&FungibleBeatoken.Vault>(/private/beatokenVault, target: FungibleBeatoken.vaultStoragePath)
            let ownerVault = acct.getCapability<&FungibleBeatoken.Vault>(/private/beatokenVault)

            acct.link<&NonFungibleBeatoken.Collection>(/private/beatokenNFTCollection, target: NonFungibleBeatoken.storageCollection)
            let ownerCollection = acct.getCapability<&NonFungibleBeatoken.Collection>(/private/beatokenNFTCollection)

            let sale <- MarketplaceBeatoken.createSaleCollection(
                ownerCollection: ownerCollection,
                ownerVault: ownerVault
            )

            acct.save<@MarketplaceBeatoken.SaleCollection>(<-sale, to: MarketplaceBeatoken.storageSale)

            acct.link<&MarketplaceBeatoken.SaleCollection{MarketplaceBeatoken.SalePublic}>(MarketplaceBeatoken.publicSale, target: MarketplaceBeatoken.storageSale)
        }
    }
}