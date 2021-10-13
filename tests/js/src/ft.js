import { deployContractByName, executeScript, mintFlow, sendTransaction } from "flow-js-testing";
import { getBeatokenAdminAddress } from "./common";

/*
 * Deploys FungibleBeatoken contract to BeatokenAdmin.
 * @throws Will throw an error if transaction is reverted.
 * @returns {Promise<*>}
 * */
export const deployFungibleBeatoken = async () => {
	const BeatokenAdmin = await getBeatokenAdminAddress();
	await mintFlow(BeatokenAdmin, "10.0");

	return deployContractByName({ to: BeatokenAdmin, name: "FungibleBeatoken" });
};

/*
 * Setups FungibleBeatoken Vault on account and exposes public capability.
 * @param {string} account - account address
 * @throws Will throw an error if transaction is reverted.
 * @returns {Promise<*>}
 * */
export const setupFungibleBeatokenOnAccount = async (account) => {
	const name = "fungibleBeatoken/setup_account";
	const signers = [account];

	return sendTransaction({ name, signers });
};

/*
 * Returns FungibleBeatoken balance for **account**.
 * @param {string} account - account address
 * @throws Will throw an error if execution will be halted
 * @returns {UFix64}
 * */
export const getFungibleBeatokenBalance = async (account) => {
	const name = "fungibleBeatoken/get_balance";
	const args = [account];

	return executeScript({ name, args });
};

/*
 * Returns FungibleBeatoken supply.
 * @throws Will throw an error if execution will be halted
 * @returns {UFix64}
 * */
export const getFungibleBeatokenSupply = async () => {
	const name = "fungibleBeatoken/get_supply";
	return executeScript({ name });
};

/*
 * Mints **amount** of FungibleBeatoken tokens and transfers them to recipient.
 * @param {string} recipient - recipient address
 * @param {string} amount - UFix64 amount to mint
 * @throws Will throw an error if transaction is reverted.
 * @returns {Promise<*>}
 * */
export const mintFungibleBeatoken = async (recipient, amount) => {
	const BeatokenAdmin = await getBeatokenAdminAddress();

	const name = "fungibleBeatoken/mint_tokens";
	const args = [recipient, amount];
	const signers = [BeatokenAdmin];

	return sendTransaction({ name, args, signers });
};

/*
 * Transfers **amount** of FungibleBeatoken tokens from **sender** account to **recipient**.
 * @param {string} sender - sender address
 * @param {string} recipient - recipient address
 * @param {string} amount - UFix64 amount to transfer
 * @throws Will throw an error if transaction is reverted.
 * @returns {Promise<*>}
 * */
export const transferFungibleBeatoken = async (sender, recipient, amount) => {
	const name = "fungibleBeatoken/transfer_tokens";
	const args = [amount, recipient];
	const signers = [sender];

	return sendTransaction({ name, args, signers });
};
