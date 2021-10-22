// SPDX-License-Identifier: MIT
import FungibleToken from "../../contracts/FungibleToken.cdc"
import FungibleBeatoken from "../../contracts/FungibleBeatoken.cdc"

transaction(amount: UFix64, to: Address) {
  var sentVault: @FungibleToken.Vault

  prepare(acct: AuthAccount) {
    let vaultRef = acct.borrow<&FungibleBeatoken.Vault>(from: FungibleBeatoken.vaultStoragePath)
        ?? panic("Could not borrow a reference to the owner's vault")

    self.sentVault <- vaultRef.withdraw(amount: amount)
  }

  execute {
    let recipient = getAccount(to)

    let receiverRef = recipient.getCapability(FungibleBeatoken.publicReceiverPath)!
          .borrow<&FungibleBeatoken.Vault{FungibleToken.Receiver}>()
          ?? panic("Could not borrow receiver reference to the recipient's Vault")

    receiverRef.deposit(from: <-self.sentVault)
  }
}
