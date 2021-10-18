import FungibleToken from "../../contracts/FungibleToken.cdc"
import FungibleBeatoken from "../../contracts/FungibleBeatoken.cdc"

pub fun main(address: Address): UFix64 {

    let account = getAccount(address)
    let vaultPath = FungibleBeatoken.publicReceiverPath
    let vaultRef = account
        .getCapability<&FungibleBeatoken.Vault{FungibleToken.Balance}>(vaultPath)
        .borrow()
        ?? panic("Could not borrow Balance reference to the Vault")

    return vaultRef.balance
}
