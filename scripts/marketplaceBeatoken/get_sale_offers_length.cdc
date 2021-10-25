// SPDX-License-Identifier: UNLICENSED
import MarketplaceBeatoken from "../../contracts/MarketplaceBeatoken.cdc"

pub fun main(account: Address): Int {
	let marketplaceRef = getAccount(account).getCapability<&AnyResource{MarketplaceBeatoken.SalePublic}>(MarketplaceBeatoken.publicSale)
       .borrow()
		?? panic("Could not borrow public storefront from address")

  	return marketplaceRef.getIDs().length
}
