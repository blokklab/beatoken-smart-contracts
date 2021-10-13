import MarketplaceBeatoken from "../../contracts/MarketplaceBeatoken.cdc"

pub fun main(account: Address): Int {
	let storefrontRef = getAccount(account).getCapability<&AnyResource{MarketplaceBeatoken.SalePublic}>(/public/NFTSale)
       .borrow()
		?? panic("Could not borrow public storefront from address")

  	return storefrontRef.getIDs().length
}
