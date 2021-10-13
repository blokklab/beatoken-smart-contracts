import FungibleBeatoken from "../../contracts/FungibleBeatoken.cdc"

transaction {
  prepare(acct: AuthAccount) {
    if acct.borrow<&FungibleBeatoken.Vault>(from: /storage/MainVault) == nil {
        acct.save(<-FungibleBeatoken.createEmptyVault(), to: /storage/MainVault)

        acct.link<&FungibleBeatoken.Vault{FungibleBeatoken.Receiver, FungibleBeatoken.Balance}>
             (/public/MainReceiver, target: /storage/MainVault)
    }
  }
}
