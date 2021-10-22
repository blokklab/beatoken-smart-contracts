// SPDX-License-Identifier: MIT
import FungibleToken from "../../contracts/FungibleToken.cdc"
import FungibleBeatoken from "../../contracts/FungibleBeatoken.cdc"

transaction {
  prepare(acct: AuthAccount) {
    let vaultPath = FungibleBeatoken.vaultStoragePath
    let publicPath = FungibleBeatoken.publicReceiverPath
    
    if acct.borrow<&FungibleBeatoken.Vault>(from: vaultPath) == nil {
        acct.save(<-FungibleBeatoken.createEmptyVault(), to: vaultPath)

        acct.link<&FungibleBeatoken.Vault{FungibleToken.Receiver, FungibleToken.Balance}>
             (publicPath, target: vaultPath)
    }
  }
}
