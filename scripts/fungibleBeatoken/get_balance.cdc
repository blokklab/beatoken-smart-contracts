import FungibleBeatoken from "../../contracts/FungibleBeatoken.cdc"

pub fun main(address: Address): UFix64 {

    let account = getAccount(address)

    let vaultRef = account.getCapability<&FungibleBeatoken.Vault{FungibleBeatoken.Balance}>(/public/MainReceiver)
        .borrow()
        ?? panic("Could not borrow Balance reference to the Vault")

    return vaultRef.balance
}
