// SPDX-License-Identifier: UNLICENSED
import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import NonFungibleBeatoken from "../../contracts/NonFungibleBeatoken.cdc"

transaction {
    prepare(acct: AuthAccount) {
        let storageCollection =  NonFungibleBeatoken.storageCollection

        if acct.borrow<&NonFungibleBeatoken.Collection>(from: storageCollection) == nil {
            acct.save<@NonFungibleBeatoken.Collection>(<-NonFungibleBeatoken.createEmptyCollection(), to: storageCollection)

            acct.link<&NonFungibleBeatoken.Collection{NonFungibleToken.CollectionPublic}>(NonFungibleBeatoken.publicReceiver, target: storageCollection)
        }
    }
}
