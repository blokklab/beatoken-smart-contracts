// SPDX-License-Identifier: MIT
import FungibleToken from "../../contracts/FungibleToken.cdc"
import FungibleBeatoken from "../../contracts/FungibleBeatoken.cdc"

transaction(recipient: Address, amount: UFix64) {

    let mintingRef: &FungibleBeatoken.VaultMinter
    let receiver: &AnyResource{FungibleToken.Receiver}

	prepare(acct: AuthAccount) {
        self.mintingRef = acct
            .borrow<&FungibleBeatoken.VaultMinter>(from: FungibleBeatoken.minterStoragePath)
            ?? panic("Could not borrow a reference to the minter")

        self.receiver = getAccount(recipient)
            .getCapability(FungibleBeatoken.publicReceiverPath)
            .borrow<&FungibleBeatoken.Vault{FungibleToken.Receiver}>()
            ?? panic("Could not borrow a reference to the receiver")
	}

    execute {
        let vault <- self.mintingRef.mintTokens(amount: amount)
        log(vault.balance)
        self.receiver.deposit(from: <- vault)
    }
}
