import NonFungibleBeatoken from "../../contracts/NonFungibleBeatoken.cdc"

transaction {
    prepare(acct: AuthAccount) {
        if acct.borrow<&NonFungibleBeatoken.Collection>(from: /storage/NFTCollection) == nil {
            acct.save<@NonFungibleBeatoken.Collection>(<-NonFungibleBeatoken.createEmptyCollection(), to: /storage/NFTCollection)

            acct.link<&{NonFungibleBeatoken.NFTReceiver}>(/public/NFTReceiver, target: /storage/NFTCollection)
        }
    }
}
