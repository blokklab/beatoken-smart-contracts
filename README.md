# Instructions:

Beatoken has developed a platform for musicians where they will be able to connect with their fans on a deeper level through NFT’s and extended merchandise.
On the platform we have created, musicians are able to share digital art, as well as physical merchandise objects, that can not be obtained from existing sources.

The marketplace will be open for all verified musician to share artwork (NFT's), with our approval. Musicians are also able to bundle NFT's in to packs and sell more than one NFT at a time. We will also implement auctions so musicians are able to sell exclusive one offs.

# Beatoken

## Beatoken Contract Addresses

`NonFungibleBeatoken.cdc`: This is a non-fungible token that takes a standard contract as a basis and expands it for the needs of the project.

| Network | Contract Address |
|---------|----------------------|
| Testnet | `0x0000000000000000` |
| Mainnet | `0x0000000000000000` |

`FungibleBeatoken.cdc`: This is a fungible token that takes a standard contract as a basis and expands it for the needs of the project.

| Network | Contract Address |
|---------|----------------------|
| Testnet | `0x0000000000000000` |
| Mainnet | `0x0000000000000000` |

`MarketplaceBeatoken.cdc`: This is a contract describing the functionality of the marketplace. An example from the official documentation is taken as a basis and expanded for our needs.

| Network | Contract Address |
|---------|----------------------|
| Testnet | `0x0000000000000000` |
| Mainnet | `0x0000000000000000` |

### Non Fungible Token Standard

The Beatoken contracts utilize the [Flow NFT standard](https://github.com/onflow/flow-nft)
which is equivalent to ERC-721 or ERC-1155 on Ethereum. If you want to build an NFT contract,
please familiarize yourself with the Flow NFT standard before starting and make sure you utilize it
in your project in order to be interoperable with other tokens and contracts that implement the standard.

### Top Shot Marketplace contract

Marketplace, which was taken from the documentation and expanded with the function of withdrawing the token from sale, as well as added Capability for the NFT wallet and storage.

## Directory Structure

The directories here are organized into contracts, scripts, and transactions.

Contracts contain the source code for the Beatoken contracts that are deployed to Flow.

Scripts contain read-only transactions to get information about
the state of someones Collection or about the state of the Beatoken contract.


Transactions contain the transactions that various admins and users can use
to perform actions in the smart contract like
minting Nft, minting Ft, and transfering Nft and Ft. Listing NFT for sale, cancel from sale

- `contracts/` : Where the Beatoken related smart contracts live.
- `transactions/` : This directory contains all the transactions
that are associated with the Top Shot smart contracts.
- `scripts/` : This contains all the read-only Cadence scripts
that are used to read information from the smart contract
or from a resource in account storage.
- `tests/` : This directory contains tests of smart contracts that use transactions and scripts

## How to run the automated tests for the contracts

See the `tests/js`how to run the automated tests.