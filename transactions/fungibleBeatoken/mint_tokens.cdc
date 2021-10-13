import FungibleBeatoken from "../../contracts/FungibleBeatoken.cdc"

transaction(recipient: Address, amount: UFix64) {

    let mintingRef: &FungibleBeatoken.VaultMinter
    let receiver: &AnyResource{FungibleBeatoken.Receiver}

	prepare(acct: AuthAccount) {
        self.mintingRef = acct.borrow<&FungibleBeatoken.VaultMinter>(from: /storage/MainMinter)
            ?? panic("Could not borrow a reference to the minter")

        self.receiver = getAccount(recipient).getCapability(/public/MainReceiver)!
              .borrow<&FungibleBeatoken.Vault{FungibleBeatoken.Receiver}>()
              ?? panic("Could not borrow a reference to the receiver")
	}

    execute {
        self.mintingRef.mintTokens(amount: amount, recipient: self.receiver)
    }
}
