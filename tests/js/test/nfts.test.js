// SPDX-License-Identifier: UNLICENSED
import path from "path";

import { emulator, init, getAccountAddress, shallPass, shallResolve, shallRevert } from "flow-js-testing";

import {
	deployNfts,
	getNftsCount,
	mintNft,
	setupNftsOnAccount,
	transferNft,
} from "../src/nfts";

// We need to set timeout for a higher number, because some transactions might take up some time
jest.setTimeout(50000);

describe("NonFungibleBeatoken", () => {
	// Instantiate emulator and path to Cadence files
	beforeEach(async () => {
		const basePath = path.resolve(__dirname, "../../../");
		const port = 7002;
		await init(basePath, { port });
		return emulator.start(port, false);
	});

	// Stop emulator, so it could be restarted
	afterEach(async () => {
		return emulator.stop();
	});

	it("shall deploy Nfts contract", async () => {
		await deployNfts();
	});

	it("shall be able to mint a Nfts", async () => {
		// Setup
		await deployNfts();
		const Alice = await getAccountAddress("Alice");
		await setupNftsOnAccount(Alice);

		// Mint instruction for Alice account shall be resolved
		await shallPass(mintNft(
			Alice,
			'Test NFT',
			'QmRNrfe1bvTD54J9D9S7tHqfGJxVbN5TNjk7iEQo9nTEST',
			'https://example.com/flow-id/',
			'Test description for NFT'
		));
	});

	it("shall be able to create a new empty NFT Collection", async () => {
		// Setup
		await deployNfts();
		const Alice = await getAccountAddress("Alice");
		await setupNftsOnAccount(Alice);

		// shall be able te read Alice collection and ensure it's empty
		await shallResolve(async () => {
			const itemCount = await getNftsCount(Alice);
			expect(itemCount).toBe(0);
		});
	});

	it("shall not be able to withdraw an NFT that doesn't exist in a collection", async () => {
		// Setup
		await deployNfts();
		const Alice = await getAccountAddress("Alice");
		const Bob = await getAccountAddress("Bob");
		await setupNftsOnAccount(Alice);
		await setupNftsOnAccount(Bob);

		// Transfer transaction shall fail for non-existent item
		await shallRevert(transferNft(Alice, Bob, 1337));
	});

	it("shall be able to withdraw an NFT and deposit to another accounts collection", async () => {
		await deployNfts();
		const Alice = await getAccountAddress("Alice");
		const Bob = await getAccountAddress("Bob");
		await setupNftsOnAccount(Alice);
		await setupNftsOnAccount(Bob);

		// Mint instruction for Alice account shall be resolved
		await shallPass(mintNft(
			Alice,
			'Test NFT',
			'QmRNrfe1bvTD54J9D9S7tHqfGJxVbN5TNjk7iEQo9nTEST',
			'https://example.com/flow-id/',
			'Test description for NFT'
		));

		// Transfer transaction shall pass
		await shallPass(transferNft(Alice, Bob, 0));
	});
});
