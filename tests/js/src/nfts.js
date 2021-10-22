// SPDX-License-Identifier: UNLICENSED
import { deployContractByName, executeScript, mintFlow, sendTransaction } from "flow-js-testing";

import { getBeatokenAdminAddress, getNonFungibleTokenAddress } from "./common";


/*
 * Deploys NonFungibleBeatoken contract to BetokenAdmin.
 * @throws Will throw an error if transaction is reverted.
 * @returns {Promise<*>}
 * */
export const deployNfts = async () => {

    const NonFungibleToken = await getNonFungibleTokenAddress();
    await mintFlow(NonFungibleToken, "10.0");

    const BeatokenAdmin = await getBeatokenAdminAddress();
    await mintFlow(BeatokenAdmin, "10.0");

    await deployContractByName({ to: NonFungibleToken, name: "NonFungibleToken"});
    await deployContractByName({ to: BeatokenAdmin, name: "NonFungibleBeatoken", addressMap: { NonFungibleToken }});
};

/*
 * Setups Nfts collection on account and exposes public capability.
 * @param {string} account - account address
 * @throws Will throw an error if transaction is reverted.
 * @returns {Promise<*>}
 * */
export const setupNftsOnAccount = async (account) => {
	const name = "nonFungibleBeatoken/setup_account";
	const signers = [account];

	return sendTransaction({ name, signers });
};

/*
 * Mints NFTS of sends it to **recipient**.
 * @param {string} recipient - recipient account address
 * @throws Will throw an error if execution will be halted
 * @returns {Promise<*>}
 * */
export const mintNft = async (recipient, name, ipfs_hash, token_uri, description) => {
	const BeatokenAdmin = await getBeatokenAdminAddress();

	const transactionName = "nonFungibleBeatoken/mint_nft";
	const args = [recipient, name, ipfs_hash, token_uri, description];
	const signers = [BeatokenAdmin];

	return sendTransaction({ name: transactionName, args, signers });
};

/*
 * Transfers NFT with id equal **itemId** from **sender** account to **recipient**.
 * @param {string} sender - sender address
 * @param {string} recipient - recipient address
 * @param {UInt64} itemId - id of the item to transfer
 * @throws Will throw an error if execution will be halted
 * @returns {Promise<*>}
 * */
export const transferNft = async (sender, recipient, itemId) => {
	const name = "nonFungibleBeatoken/transfer_nft";
	const args = [recipient, itemId];
	const signers = [sender];

	return sendTransaction({ name, args, signers });
};

/*
 * Returns the NFT with the provided **id** from an account collection.
 * @param {string} account - account address
 * @param {UInt64} itemID - NFT id
 * @throws Will throw an error if execution will be halted
 * @returns {UInt64}
 * */
export const getNftItem = async (account, itemID) => {
	const name = "nonFungibleBeatoken/get_nft_item";
	const args = [account, itemID];

	return executeScript({ name, args });
};

/*
 * Returns the number of NFTS in an account's collection.
 * @param {string} account - account address
 * @throws Will throw an error if execution will be halted
 * @returns {UInt64}
 * */
export const getNftsCount = async (account) => {
	const name = "nonFungibleBeatoken/get_collection_length";
	const args = [account];

	return executeScript({ name, args });
};


/*
 * Returns the IDS of NFTS in an account's collection.
 * @param {string} account - account address
 * @throws Will throw an error if execution will be halted
 * @returns {UInt64}
 * */
export const getNftsIds = async (account) => {
	const name = "nonFungibleBeatoken/get_collection_ids";
	const args = [account];

	return executeScript({ name, args });
};
