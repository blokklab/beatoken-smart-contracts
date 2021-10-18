import path from "path";

import { emulator, init, getAccountAddress, shallPass, shallResolve, shallRevert } from "flow-js-testing";

import { toUFix64, getBeatokenAdminAddress } from "../src/common";
import {
	deployFungibleBeatoken,
	setupFungibleBeatokenOnAccount,
	getFungibleBeatokenBalance,
	getFungibleBeatokenSupply,
	mintFungibleBeatoken,
	transferFungibleBeatoken,
} from "../src/ft";

// We need to set timeout for a higher number, because some transactions might take up some time
jest.setTimeout(500000);

describe("FungibleBeatoken", () => {
	// Instantiate emulator and path to Cadence files
	beforeEach(async () => {
		const basePath = path.resolve(__dirname, "../../../");
		const port = 7001;
		await init(basePath, { port });
		return emulator.start(port, false);
	});

	// Stop emulator, so it could be restarted
	afterEach(async () => {
		return emulator.stop();
	});

	it("shall have initialized supply field correctly", async () => {
		// Deploy contract
		await deployFungibleBeatoken();

		await shallResolve(async () => {
			const supply = await getFungibleBeatokenSupply();
			expect(supply).toBe(toUFix64(0));
		});
	});

	it("shall be able to create empty Vault that doesn't affect supply", async () => {
		// Setup
		await deployFungibleBeatoken();
		const Alice = await getAccountAddress("Alice");
		await shallPass(setupFungibleBeatokenOnAccount(Alice));

		await shallResolve(async () => {
			const supply = await getFungibleBeatokenSupply();
			const aliceBalance = await getFungibleBeatokenBalance(Alice);
			expect(supply).toBe(toUFix64(0));
			expect(aliceBalance).toBe(toUFix64(0));
		});
	});

	it("shall not be able to mint 0 tokens", async () => {
		// Setup
		await deployFungibleBeatoken();
		const Alice = await getAccountAddress("Alice");
		await setupFungibleBeatokenOnAccount(Alice);
		const amount = toUFix64(0);

		// Mint instruction with amount equal to 0 shall be reverted
		await shallPass(mintFungibleBeatoken(Alice, amount));
		await shallResolve(async () => {
			const balance = await getFungibleBeatokenBalance(Alice);
			expect(balance).toBe(amount);
		});
	});

	it("shall mint tokens, deposit, and update balance and total supply", async () => {
		// Setup
		await deployFungibleBeatoken();
		const Alice = await getAccountAddress("Alice");
		await setupFungibleBeatokenOnAccount(Alice);
		const amount = toUFix64(50);

		// Mint Kibble tokens for Alice
		await shallPass(mintFungibleBeatoken(Alice, amount));

		// Check Kibble total supply and Alice's balance
		await shallResolve(async () => {
			// Check Alice balance to equal amount
			const balance = await getFungibleBeatokenBalance(Alice);

			expect(balance).toBe(amount);

			// Check Kibble supply to equal amount
			const supply = await getFungibleBeatokenSupply();
			expect(supply).toBe(amount);
		});
	});

	it("shall not be able to withdraw more than the balance of the Vault", async () => {
		// Setup
		await deployFungibleBeatoken();
		const BeatokenAdmin = await getBeatokenAdminAddress();
		const Alice = await getAccountAddress("Alice");
		await setupFungibleBeatokenOnAccount(Alice);

		// Set amounts
		const amount = toUFix64(1000);
		const overflowAmount = toUFix64(30000);


		const beforeBeatokenAdminBalance = await getFungibleBeatokenBalance(BeatokenAdmin);

		// Mint instruction shall resolve
		await shallResolve(mintFungibleBeatoken(BeatokenAdmin, amount));

		const BeatokenAdminBalance = await getFungibleBeatokenBalance(BeatokenAdmin);

		// Transaction shall revert
		await shallRevert(transferFungibleBeatoken(BeatokenAdmin, Alice, overflowAmount));

		// Balances shall be intact
		await shallResolve(async () => {
			const aliceBalance = await getFungibleBeatokenBalance(Alice);
			expect(aliceBalance).toBe(toUFix64(0));

			const BeatokenAdminBalance = await getFungibleBeatokenBalance(BeatokenAdmin);
			expect(BeatokenAdminBalance).toBe(amount);
		});
	});

	it("shall be able to withdraw and deposit tokens from a Vault", async () => {
		await deployFungibleBeatoken();
		const BeatokenAdmin = await getBeatokenAdminAddress();
		const Alice = await getAccountAddress("Alice");
		await setupFungibleBeatokenOnAccount(Alice);

		// Set amounts
		const amount = toUFix64(1000);
		const smallerflowAmount = toUFix64(300);

		await mintFungibleBeatoken(BeatokenAdmin, amount);
		const BeatokenAdminBalance = await getFungibleBeatokenBalance(BeatokenAdmin);
		expect(BeatokenAdminBalance).toBe(amount);


		await shallPass(transferFungibleBeatoken(BeatokenAdmin, Alice, smallerflowAmount));

		await shallResolve(async () => {
			// Balances shall be updated
			const BeatokenAdminBalance = await getFungibleBeatokenBalance(BeatokenAdmin);
			expect(BeatokenAdminBalance).toBe(toUFix64(700));

			const aliceBalance = await getFungibleBeatokenBalance(Alice);
			expect(aliceBalance).toBe(toUFix64(300));

			const supply = await getFungibleBeatokenSupply();
			expect(supply).toBe(toUFix64(1000));
		});
	});
});
