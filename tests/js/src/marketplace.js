import { deployContractByName, executeScript, sendTransaction } from "flow-js-testing";
import { getBeatokenAdminAddress, getFungibleTokenAddress, getNonFungibleTokenAddress } from "./common";
import { deployFungibleBeatoken, setupFungibleBeatokenOnAccount } from "./ft";
import { deployNfts, setupNftsOnAccount } from "./nfts";

/*
 * Deploys FungibleToken, Nfts and MarketplaceBeatoken contracts to BeatokenAdmin.
 * @throws Will throw an error if transaction is reverted.
 * @returns {Promise<*>}
 * */
export const deployMarketplaceBeatoken = async () => {
	const BeatokenAdmin = await getBeatokenAdminAddress();
	const FungibleToken = await getFungibleTokenAddress();
	const NonFungibleToken = await getNonFungibleTokenAddress();

	await deployFungibleBeatoken();
	await deployNfts();

	const addressMap = {
		FungibleToken: FungibleToken,
		NonFungibleToken: NonFungibleToken,
		NonFungibleBeatoken: BeatokenAdmin,
		FungibleBeatoken: BeatokenAdmin
	};

	return deployContractByName({ to: BeatokenAdmin, name: "MarketplaceBeatoken", addressMap });
};

/*
 * Sets up MarketplaceBeatoken on account and exposes public capability.
 * @param {string} account - account address
 * @throws Will throw an error if transaction is reverted.
 * @returns {Promise<*>}
 * */
export const setupMarketplaceBeatokenOnAccount = async (account) => {
	// Account shall be able to store NFTS and operate FT
	await setupFungibleBeatokenOnAccount(account);
	await setupNftsOnAccount(account);

	const name = "marketplaceBeatoken/setup_account";
	const signers = [account];

	return sendTransaction({ name, signers });
};

/*
 * Lists item with id equal to **item** id for sale with specified **price**.
 * @param {string} seller - seller account address
 * @param {UInt64} itemId - id of item to sell
 * @param {UFix64} price - price
 * @throws Will throw an error if transaction is reverted.
 * @returns {Promise<*>}
 * */
export const sellItem = async (seller, itemId, price) => {
	const name = "marketplaceBeatoken/sell_item";
	const args = [itemId, price];
	const signers = [seller];

	return sendTransaction({ name, args, signers });
};

/*
 * Buys item with id equal to **item** id for **price** from **seller**.
 * @param {string} buyer - buyer account address
 * @param {UInt64} resourceId - resource uuid of item to sell
 * @param {string} seller - seller account address
 * @throws Will throw an error if transaction is reverted.
 * @returns {Promise<*>}
 * */
export const buyItem = async (buyer, seller, itemId, price) => {
	const name = "marketplaceBeatoken/buy_item";
	const args = [seller, itemId, price];
	const signers = [buyer];

	return sendTransaction({ name, args, signers });
};

/*
 * Removes item with id equal to **item** from sale.
 * @param {string} owner - owner address
 * @param {UInt64} itemId - id of item to remove
 * @throws Will throw an error if transaction is reverted.
 * @returns {Promise<*>}
 * */
export const removeItem = async (owner, itemId) => {
	const name = "marketplaceBeatoken/remove_item";
	const signers = [owner];
	const args = [itemId];

	return sendTransaction({ name, args, signers });
};

/*
 * Returns the number of items for sale in a given account's storefront.
 * @param {string} account - account address
 * @throws Will throw an error if execution will be halted
 * @returns {UInt64}
 * */
export const getSaleOfferCount = async (account) => {
	const name = "marketplaceBeatoken/get_sale_offers_length";
	const args = [account];

	return executeScript({ name, args });
};
