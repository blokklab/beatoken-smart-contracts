import FungibleBeatoken from "../../contracts/FungibleBeatoken.cdc"

transaction(amount: UFix64, to: Address) {
  var sentVault: @FungibleBeatoken.Vault

  prepare(acct: AuthAccount) {
    let vaultRef = acct.borrow<&FungibleBeatoken.Vault>(from: /storage/MainVault)
        ?? panic("Could not borrow a reference to the owner's vault")

    self.sentVault <- vaultRef.withdraw(amount: amount)
  }

  execute {
    let recipient = getAccount(to)

    let receiverRef = recipient.getCapability(/public/MainReceiver)!
          .borrow<&FungibleBeatoken.Vault{FungibleBeatoken.Receiver}>()
          ?? panic("Could not borrow receiver reference to the recipient's Vault")

    receiverRef.deposit(from: <-self.sentVault)
  }
}
