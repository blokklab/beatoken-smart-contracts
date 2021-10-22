// SPDX-License-Identifier: UNLICENSED
import path from "path";

import { emulator, init, getAccountAddress, shallPass, shallRevert } from "flow-js-testing";

import { toUFix64 } from "../src/common";
import { mintFungibleBeatoken } from "../src/ft";
import { getNftsCount, mintNft, getNftItem } from "../src/nfts";
import {
	deployMarketplaceBeatoken,
	buyItem,
	sellItem,
	removeItem,
	setupMarketplaceBeatokenOnAccount,
	getSaleOfferCount,
} from "../src/marketplace";

// We need to set timeout for a higher number, because some transactions might take up some time
jest.setTimeout(500000);

describe("MarketplaceBeatoken", () => {
	beforeEach(async () => {
		const basePath = path.resolve(__dirname, "../../../");
		const port = 7003;
		await init(basePath, { port });
		return emulator.start(port, false);
	});

	// Stop emulator, so it could be restarted
	afterEach(async () => {
		return emulator.stop();
	});

	it("shall deploy Marketplace contract", async () => {
		await shallPass(deployMarketplaceBeatoken());
	});

	it("shall be able to create an empty Marketplace", async () => {
		// Setup
		await deployMarketplaceBeatoken();
		const Alice = await getAccountAddress("Alice");

		await shallPass(setupMarketplaceBeatokenOnAccount(Alice));
	});

	it("shall be able to create a sale offer", async () => {
		// Setup
		await deployMarketplaceBeatoken();
		const Alice = await getAccountAddress("Alice");
		await setupMarketplaceBeatokenOnAccount(Alice);

		// Mint NFT for Alice's account
		await shallPass(mintNft(
			Alice,
			'Test NFT',
			'QmRNrfe1bvTD54J9D9S7tHqfGJxVbN5TNjk7iEQo9nTEST',
			'https://example.com/flow-id/',
			'Test description for NFT'
		));

		const itemID = 0;

		await shallPass(sellItem(Alice, itemID, toUFix64(1.11)));
	});

	it("shall be able to accept a sale offer", async () => {
		// Setup
		await deployMarketplaceBeatoken();

		// Setup seller account
		const Alice = await getAccountAddress("Alice");
		await setupMarketplaceBeatokenOnAccount(Alice);
		await shallPass(mintNft(
			Alice,
			'Test NFT',
			'QmRNrfe1bvTD54J9D9S7tHqfGJxVbN5TNjk7iEQo9nTEST',
			'https://example.com/flow-id/',
			'Test description for NFT'
		));

		const itemId = 0;

		// Setup buyer account
		const Bob = await getAccountAddress("Bob");
		await setupMarketplaceBeatokenOnAccount(Bob);

		await shallPass(mintFungibleBeatoken(Bob, toUFix64(100)));

		const price = toUFix64(1.11);

		// Bob shall be able to buy from Alice
		await shallPass(sellItem(Alice, itemId, price));

		await shallPass(buyItem(Bob, Alice, itemId, price));

		// Bob is trying to buy the token he just bought
		await shallRevert(buyItem(Bob, Alice, itemId, price));

		const itemCount = await getNftsCount(Bob);
		expect(itemCount).toBe(1);

		const offerCount = await getSaleOfferCount(Alice);
		expect(offerCount).toBe(0);
	});

	it("shall be able to remove a sale offer", async () => {
		// Deploy contracts
		await shallPass(deployMarketplaceBeatoken());

		// Setup Alice account
		const Alice = await getAccountAddress("Alice");
		await shallPass(setupMarketplaceBeatokenOnAccount(Alice));

		// Mint instruction shall pass
		await shallPass(mintNft(
			Alice,
			'Test NFT',
			'QmRNrfe1bvTD54J9D9S7tHqfGJxVbN5TNjk7iEQo9nTEST',
			'https://example.com/flow-id/',
			'Test description for NFT'
		));

		const itemId = 0;

		await getNftItem(Alice, itemId);

		// Listing item for sale shall pass
		await shallPass(sellItem(Alice, itemId, toUFix64(1.11)));

		// Alice shall be able to remove item from sale
		await shallPass(removeItem(Alice, itemId));

		const offerCount = await getSaleOfferCount(Alice);
		expect(offerCount).toBe(0);
	});
});
